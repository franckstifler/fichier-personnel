defmodule EduCountWeb.SubDivisionLive.Form do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage sub_division records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="sub_division-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:region_id]}
          prompt="Select a region"
          type="select"
          label="Region"
          options={Enum.map(@regions, &{&1.name, &1.id})}
        />
        <.input
          field={@form[:division_id]}
          prompt="Select a division"
          type="select"
          label={gettext("Division")}
          options={Enum.map(@divisions, &{&1.name, &1.id})}
        />

        <.button phx-disable-with="Saving..." variant="primary">{gettext("Save")}</.button>
        <.button navigate={return_path(@return_to, @sub_division)}>{gettext("Cancel")}</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    sub_division =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(EduCount.Census.SubDivision, id, load: [division: :region])
      end

    action = if is_nil(sub_division), do: gettext("New"), else: gettext("Edit")
    page_title = action <> " " <> gettext("Sub division")
    regions = EduCount.Census.list_regions_alphabetically!()

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(regions: regions)
     |> assign(sub_division: sub_division)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event(
        "validate",
        %{"_target" => ["sub_division", "region_id"], "sub_division" => sub_division_params},
        socket
      ) do
    region_id = sub_division_params["region_id"]

    divisions =
      if region_id not in ["", nil] do
        EduCount.Census.list_region_divisions!(region_id)
      else
        socket.assigns.divitions
      end

    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, sub_division_params))
     |> assign(:divisions, divisions)}
  end

  def handle_event("validate", %{"sub_division" => sub_division_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, sub_division_params))}
  end

  def handle_event("save", %{"sub_division" => sub_division_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: sub_division_params) do
      {:ok, sub_division} ->
        notify_parent({:saved, sub_division})

        socket =
          socket
          |> put_flash(:info, "Sub division #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, sub_division))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{sub_division: sub_division}} = socket) do
    {form, divisions} =
      if sub_division do
        form =
          AshPhoenix.Form.for_update(sub_division, :update,
            as: "sub_division",
            prepare_source: fn changeset ->
              changeset
              |> Ash.Changeset.set_argument(:region_id, sub_division.division.region_id)
            end
          )

        divisions = EduCount.Census.list_region_divisions!(sub_division.division.region_id)
        {form, divisions}
      else
        form =
          AshPhoenix.Form.for_create(EduCount.Census.SubDivision, :create, as: "sub_division")

        {form, []}
      end

    socket
    |> assign(:divisions, divisions)
    |> assign(form: to_form(form))
  end

  defp return_path("index", _sub_division), do: ~p"/config/sub_divisions"
  defp return_path("show", sub_division), do: ~p"/config/sub_divisions/#{sub_division.id}"
end
