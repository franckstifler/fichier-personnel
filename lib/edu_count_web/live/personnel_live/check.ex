defmodule EduCountWeb.PersonnelLive.Check do
  use EduCountWeb, :live_view
  require Ash.Query

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.form flash={@flash}>
      <.header>
        {@page_title}
      </.header>

      <.form for={@form} id="check-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:matricule]} type="text" label={gettext("Matricule")} />
        <.input field={@form[:date_of_birth]} type="date" label={gettext("Date of birth")} />

        <.button phx-disable-with="Saving..." variant="primary">{gettext("Check")}</.button>
        <.button navigate={~p"/"}>{gettext("Cancel")}</.button>
      </.form>
    </Layouts.form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    form =
      AshPhoenix.Form.for_create(EduCountWeb.PersonnelLive.CheckForm, :create, as: "check")

    {:ok,
     socket
     |> assign(:form, to_form(form))
     |> assign(:page_title, gettext("Check your registration"))}
  end

  @impl true
  def handle_event("validate", %{"check" => check_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, check_params))}
  end

  def handle_event("save", %{"check" => check_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, check_params)
    dbg(form)

    case form.source.valid? do
      true ->
        matricule = AshPhoenix.Form.value(form, :matricule)
        date_of_birth = AshPhoenix.Form.value(form, :date_of_birth)

        result =
          EduCount.Census.Personnel
          |> Ash.Query.for_read(:read)
          |> Ash.Query.filter(matricule == ^matricule and date_of_birth == ^date_of_birth)
          |> Ash.Query.select([:id])
          |> Ash.read!()

        case result do
          [] ->
            {:noreply,
             socket
             |> put_flash(:error, gettext("No registration found with the provided information."))
             |> assign(:form, form)}

          [%{id: id}] ->
            {:noreply, push_navigate(socket, to: ~p"/personnels/view/#{id}")}
        end

      _ ->
        {:noreply, assign(socket, form: form)}
    end
  end
end
