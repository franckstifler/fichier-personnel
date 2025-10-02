defmodule EduCountWeb.PersonnelLive.View do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@personnel.full_name}

        <:actions>
          <.button
            variant="primary"
            href="mailto:francktchowa@gmail.com?subject=Fichier%20du%20Personnel%20Support"
          >
            <.icon name="hero-pencil-square" /> {gettext("Request Edit")}
          </.button>
        </:actions>
      </.header>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
        <div class="card bg-base-200 shadow-md ">
          <div class="card-body">
            <div class="card-title">{gettext("Personal information")}</div>
            <.list>
              <:item title={gettext("Full name")}>{@personnel.full_name}</:item>

              <:item :if={@personnel.maiden_name} title={gettext("Maiden name")}>
                {@personnel.maiden_name}
              </:item>

              <:item title={gettext("Gender")}>
                {EduCount.Census.Enums.Gender.description(@personnel.gender)}
              </:item>

              <:item title={gettext("Date of birth")}>
                {@personnel.date_of_birth} {gettext("at")} {@personnel.place_of_birth}
              </:item>

              <:item title={gettext("Matrimonial status")}>
                {EduCount.Census.Enums.MatrimonialStatus.description(@personnel.matrimonial_status)} ({@personnel.children_count})
              </:item>

              <:item title={gettext("Matricule")}>
                {@personnel.matricule}
              </:item>
              <:item title={gettext("Language")}>
                {EduCount.Census.Enums.Language.description(@personnel.language)}
              </:item>
              <:item title={gettext("Origin")}>{@personnel.full_region_of_origin}</:item>
              <:item title={gettext("Telephone")}>{@personnel.telephone}</:item>
              <:item title={gettext("Email")}>{@personnel.email}</:item>
            </.list>
          </div>
        </div>
        <div class="card bg-base-200 shadow-md ">
          <div class="card-body">
            <div class="card-title">{gettext("Professional information")}</div>
            <.list>
              <:item title={gettext("Grade")}>
                {EduCount.Census.Enums.Grade.description(@personnel.grade)}
              </:item>

              <:item title={gettext("Professional diploma")}>{@personnel.professional_diploma}</:item>

              <:item title={gettext("Professional diploma option")}>
                {EduCount.Census.Enums.ProfessionalDiplomaOption.description(
                  @personnel.professional_diploma_option
                )}
              </:item>

              <:item title={gettext("Degree subject")}>{@personnel.degree_subject}</:item>

              <:item title={gettext("Other diplomas")}>
                <ul>
                  <li :for={diploma <- @personnel.other_diplomas}>
                    <p>
                      <strong>{diploma.diploma}</strong>
                      {diploma.subject && "(#{diploma.subject})"}
                    </p>
                  </li>
                </ul>
              </:item>

              <:item title={gettext("Fonction")}>
                <.fonction_component fonction={@personnel.fonction} />
              </:item>

              <:item title={gettext("First effective service date")}>
                {@personnel.first_effective_service_date}
              </:item>

              <:item title={gettext("Current post effective service date")}>
                {@personnel.current_post_effective_service_date}
              </:item>

              <:item title={gettext("Region appointed")}>
                {@personnel.full_region_appointed}
              </:item>
            </.list>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Personnel")
     |> assign(
       :personnel,
       Ash.get!(EduCount.Census.Personnel, id,
         load: [:full_name, :full_region_appointed, :full_region_of_origin]
       )
     )}
  end

  def fonction_component(assigns) do
    ~H"""
    <%= case @fonction do %>
      <% :teacher -> %>
        <div class="badge badge-sm badge-info">
          {EduCount.Census.Enums.Fonction.description(@fonction)}
        </div>
      <% :hod -> %>
        <div class="badge badge-sm badge-success">
          {EduCount.Census.Enums.Fonction.description(@fonction)}
        </div>
    <% end %>
    """
  end
end
