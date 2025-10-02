defmodule EduCountWeb.RegionLive.Show do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@region.name}

        <:actions>
          <.button navigate={~p"/config/regions"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/config/regions/#{@region}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> {gettext("Edit Region")}
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@region.name}</:item>
        <:item title="Id">{@region.id}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Show Region"))
     |> assign(:region, Ash.get!(EduCount.Census.Region, id))}
  end
end
