defmodule EduCountWeb.PersonnelLive.Index do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {gettext("Listing Personnels")}
        <:actions>
          <a class="btn btn-seconday" href={~p"/config/personnels/download"} target="_blank">
            <.icon name="hero-arrow-down" /> {gettext("Download")}
          </a>
        </:actions>
      </.header>

      <Cinder.Table.table
        id="personnels"
        resource={EduCount.Census.Personnel}
        query_opts={[load: [:full_name, :sub_division_appointed, :sub_division_of_origin]]}
        row_click={fn personnel -> JS.navigate(~p"/config/personnels/#{personnel}") end}
      >
        <:col
          :let={personnel}
          label={gettext("Full name")}
          field="full_name"
          filter
          sort
          class="font-semibold"
        >
          <p>{personnel.full_name}</p>
          <p :if={personnel.maiden_name} class="">{personnel.maiden_name}</p>
        </:col>

        <:col :let={personnel} label={gettext("Gender")} field="gender" filter>
          {EduCount.Census.Enums.Gender.description(personnel.gender)}
        </:col>

        <:col :let={personnel} label={gettext("Date of birth")} field="date_of_birth">
          <p>{personnel.date_of_birth}</p>
          <p :if={personnel.place_of_birth} class="">{personnel.place_of_birth}</p>
        </:col>

        <:col
          :let={personnel}
          label={gettext("Status")}
          field="matrimonial_status"
          filter
          class="font-semibold"
        >
          {EduCount.Census.Enums.MatrimonialStatus.description(personnel.matrimonial_status)} ({personnel.children_count})
        </:col>

        <:col :let={personnel} label={gettext("Matricule")} field="matricule" filter sort>
          {personnel.matricule}
        </:col>

        <:col :let={personnel} label={gettext("Grade")} field="grade">
          <p>{EduCount.Census.Enums.Grade.description(personnel.grade)}</p>
          <p>
            {personnel.professional_diploma} {gettext("in")} {EduCount.Census.Enums.ProfessionalDiplomaOption.description(
              personnel.professional_diploma_option
            )}
          </p>
        </:col>

        <%!-- <:col :let={personnel} label="Degree subject">{personnel.degree_subject}</:col> --%>

        <%!-- <:col :let={personnel} label="Other diplomas">{personnel.other_diplomas}</:col> --%>

        <:col :let={personnel} label={gettext("Fonction")} field="fonction">
          <EduCountWeb.PersonnelLive.Show.fonction_component fonction={personnel.fonction} />
        </:col>

        <:col :let={personnel} label={gettext("Dates")}>
          <p>PSFP: {personnel.first_effective_service_date}</p>
          <p>PSPA: {personnel.current_post_effective_service_date}</p>
        </:col>
        ]
        <:filter
          label={gettext("Grade")}
          field="grade"
          type="select"
          options={
            EduCount.Census.Enums.Grade.values()
            |> Enum.map(fn value ->
              {EduCount.Census.Enums.Grade.description(value), value}
            end)
          }
        />
        <:filter
          label={gettext("Fonction")}
          field="fonction"
          type="select"
          options={
            EduCount.Census.Enums.Fonction.values()
            |> Enum.map(fn value ->
              {EduCount.Census.Enums.Fonction.description(value), value}
            end)
          }
        />
        <:filter
          label={gettext("Language")}
          field="language"
          type="select"
          options={
            EduCount.Census.Enums.Language.values()
            |> Enum.map(fn value ->
              {EduCount.Census.Enums.Language.description(value), value}
            end)
          }
        />
        <:filter label={gettext("Professional diploma")} field="professional_diploma" />

        <:filter
          label={gettext("Professional diploma option")}
          field="professional_diploma_option"
          type="select"
          options={
            EduCount.Census.Enums.ProfessionalDiplomaOption.values()
            |> Enum.map(fn value ->
              {EduCount.Census.Enums.ProfessionalDiplomaOption.description(value), value}
            end)
          }
        />

        <:filter
          label={gettext("First post effective service date")}
          field="first_effective_service_date"
          type="date_range"
        />

        <:filter
          label={gettext("Current post effective service date")}
          field="current_post_effective_service_date"
          type="date_range"
        />

        <:filter label="Dob" field="date_of_birth" type="date_range" />

        <:col :let={personnel} label="Contacts">
          <p>{personnel.telephone}</p>
          <p>{personnel.email}</p>
        </:col>
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
