defmodule EduCountWeb.RegionLive.Form do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage region records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="region-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label={gettext("Name")} />

        <.button phx-disable-with="Saving..." variant="primary">{gettext("Save Region")}</.button>
        <.button navigate={return_path(@return_to, @region)}>{gettext("Cancel")}</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    region =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(EduCount.Census.Region, id)
      end

    action = if is_nil(region), do: gettext("New"), else: gettext("Edit")
    page_title = action <> " " <> gettext("Region")

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(region: region)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"region" => region_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, region_params))}
  end

  def handle_event("save", %{"region" => region_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: region_params) do
      {:ok, region} ->
        notify_parent({:saved, region})

        socket =
          socket
          |> put_flash(:info, "Region #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, region))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{region: region}} = socket) do
    form =
      if region do
        AshPhoenix.Form.for_update(region, :update, as: "region")
      else
        AshPhoenix.Form.for_create(EduCount.Census.Region, :create, as: "region")
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _region), do: ~p"/config/regions"
  defp return_path("show", region), do: ~p"/config/regions/#{region.id}"
end
