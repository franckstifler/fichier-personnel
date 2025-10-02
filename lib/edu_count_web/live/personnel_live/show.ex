defmodule EduCountWeb.PersonnelLive.Show do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Personnel {@personnel.id}
        <:subtitle>This is a personnel record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/personnels"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/personnels/#{@personnel}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit Personnel
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Last name">{@personnel.last_name}</:item>

        <:item title="First name">{@personnel.first_name}</:item>

        <:item title="Maiden name">{@personnel.maiden_name}</:item>

        <:item title="Gender">{@personnel.gender}</:item>

        <:item title="Date of birth">{@personnel.date_of_birth}</:item>

        <:item title="Place of birth">{@personnel.place_of_birth}</:item>

        <:item title="Matrimonial status">{@personnel.matrimonial_status}</:item>

        <:item title="Children count">{@personnel.children_count}</:item>

        <:item title="Matricule">{@personnel.matricule}</:item>

        <:item title="Grade">{@personnel.grade}</:item>

        <:item title="Professional title">{@personnel.professional_title}</:item>

        <:item title="Professional title option">{@personnel.professional_title_option}</:item>

        <:item title="Degree subject">{@personnel.degree_subject}</:item>

        <:item title="Other diplomas">{@personnel.other_diplomas}</:item>

        <:item title="Fonction">{@personnel.fonction}</:item>

        <:item title="First effective service date">{@personnel.first_effective_service_date}</:item>

        <:item title="Current post effective service date">
          {@personnel.current_post_effective_service_date}
        </:item>

        <:item title="Telephone">{@personnel.telephone}</:item>

        <:item title="Email">{@personnel.email}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Personnel")
     |> assign(:personnel, Ash.get!(EduCount.Census.Personnel, id))}
  end
end
