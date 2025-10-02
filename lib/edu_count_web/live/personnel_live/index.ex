defmodule EduCountWeb.PersonnelLive.Index do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {gettext("Listing Personnels")}
        <%!-- <:actions>
          <.button variant="primary" navigate={~p"/personnels/new"}>
            <.icon name="hero-plus" /> New Personnel
          </.button>
        </:actions> --%>
      </.header>

      <Cinder.Table.table
        id="personnels"
        resource={EduCount.Census.Personnel}
        row_click={fn personnel -> JS.navigate(~p"/personnels/#{personnel}") end}
      >
        <:col :let={personnel} label="Last name" field="last_name" filter sort>
          {personnel.last_name}
        </:col>

        <:col :let={personnel} label="First name" field="first_name" filter sort>
          {personnel.first_name}
        </:col>

        <:col :let={personnel} label="Maiden name">{personnel.maiden_name}</:col>

        <:col :let={personnel} label="Gender" field="gender" filter>{personnel.gender}</:col>

        <:col :let={personnel} label="Date of birth" field="date_of_birth" filter>
          {personnel.date_of_birth}
        </:col>

        <:col :let={personnel} label="Place of birth" field="place_of_birth" filter>
          {personnel.place_of_birth}
        </:col>

        <:col :let={personnel} label="Matrimonial status" field="matrimonial_status" filter>
          {personnel.matrimonial_status}
        </:col>

        <:col :let={personnel} label="Children count">{personnel.children_count}</:col>

        <:col :let={personnel} label="Matricule" field="matricule" filter sort>
          {personnel.matricule}
        </:col>

        <:col :let={personnel} label="Grade" field="grade" filter>{personnel.grade}</:col>

        <:col :let={personnel} label="Professional diploma" field="professional_diploma" filter>
          {personnel.professional_diploma}
        </:col>

        <:col :let={personnel} label="Professional diploma option" field="professional_diploma_option" filter>
          {personnel.professional_diploma_option}
        </:col>

        <:col :let={personnel} label="Degree subject">{personnel.degree_subject}</:col>

        <:col :let={personnel} label="Other diplomas">{personnel.other_diplomas}</:col>

        <:col :let={personnel} label="Fonction" field="fonction" filter>{personnel.fonction}</:col>

        <:col
          :let={personnel}
          label="First effective service date"
          field="first_effective_service_date"
          filter
        >
          {personnel.first_effective_service_date}
        </:col>

        <:col
          :let={personnel}
          label="Current post effective service date"
          field="current_post_effective_service_date"
          filter
        >
          {personnel.current_post_effective_service_date}
        </:col>

        <:col :let={personnel} label="Telephone">{personnel.telephone}</:col>

        <:col :let={personnel} label="Email">{personnel.email}</:col>

        <:action :let={personnel}>
          <div class="sr-only">
            <.link navigate={~p"/personnels/#{personnel}"}>Show</.link>
          </div>

          <.link navigate={~p"/personnels/#{personnel}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, personnel}}>
          <.link
            phx-click={JS.push("delete", value: %{id: personnel.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </Cinder.Table.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Personnels")
     |> stream(:personnels, Ash.read!(EduCount.Census.Personnel))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    personnel = Ash.get!(EduCount.Census.Personnel, id)
    Ash.destroy!(personnel)

    {:noreply, stream_delete(socket, :personnels, personnel)}
  end
end
