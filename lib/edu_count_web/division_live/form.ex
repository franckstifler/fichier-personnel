defmodule EduCountWeb.DivisionLive.Form do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
      </.header>

      <.form for={@form} id="division-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label={gettext("Name")} />
        <.input
          field={@form[:region_id]}
          type="select"
          label={gettext("Region")}
          options={Enum.map(@regions, &{&1.name, &1.id})}
        />

        <.button phx-disable-with="Saving..." variant="primary">{gettext("Save Division")}</.button>
        <.button navigate={return_path(@return_to, @division)}>{gettext("Cancel")}</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    division =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(EduCount.Census.Division, id)
      end

    action = if is_nil(division), do: gettext("New"), else: gettext("Edit")
    page_title = action <> " " <> gettext("Division")
    regions = EduCount.Census.list_regions_alphabetically!()

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(division: division)
     |> assign(regions: regions)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"division" => division_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, division_params))}
  end

  def handle_event("save", %{"division" => division_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: division_params) do
      {:ok, division} ->
        notify_parent({:saved, division})

        socket =
          socket
          |> put_flash(:info, "Division #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, division))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{division: division}} = socket) do
    form =
      if division do
        AshPhoenix.Form.for_update(division, :update, as: "division")
      else
        AshPhoenix.Form.for_create(EduCount.Census.Division, :create, as: "division")
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _division), do: ~p"/admin/divisions"
  defp return_path("show", division), do: ~p"/admin/divisions/#{division.id}"
end
