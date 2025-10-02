defmodule EduCountWeb.SubDivisionLive.Show do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@sub_division.name}
        <:subtitle>This is a sub_division record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/config/sub_divisions"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/config/sub_divisions/#{@sub_division}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> {gettext("Edit")}
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title={gettext("Name")}>{@sub_division.name}</:item>
        <:item title={gettext("Division")}>{@sub_division.division.name}</:item>
        <:item title={gettext("Region")}>{@sub_division.division.region.name}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Show Sub division"))
     |> assign(
       :sub_division,
       Ash.get!(EduCount.Census.SubDivision, id, load: [division: :region])
     )}
  end
end
