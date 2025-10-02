defmodule EduCountWeb.DivisionLive.Show do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@division.name}
        <:actions>
          <.button navigate={~p"/config/divisions"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/config/divisions/#{@division}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> {gettext("Edit Division")}
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title={gettext("Name")}>{@division.name}</:item>
        <:item title={gettext("Region")}>{@division.region.name}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Show Division"))
     |> assign(:division, Ash.get!(EduCount.Census.Division, id, load: [:region]))}
  end
end
