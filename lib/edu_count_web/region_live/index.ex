defmodule EduCountWeb.RegionLive.Index do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Regions
        <:actions>
          <.button variant="primary" navigate={~p"/admin/regions/new"}>
            <.icon name="hero-plus" /> New Region
          </.button>
        </:actions>
      </.header>

      <.table
        id="regions"
        rows={@streams.regions}
        row_click={fn {_id, region} -> JS.navigate(~p"/admin/regions/#{region}") end}
      >
        <%!-- <:col :let={{_id, region}} label="Id">{region.id}</:col> --%>

        <:col :let={{_id, region}} label="Name">{region.name}</:col>

        <:action :let={{_id, region}}>
          <div class="sr-only">
            <.link navigate={~p"/admin/regions/#{region}"}>Show</.link>
          </div>

          <.link navigate={~p"/admin/regions/#{region}/edit"}>Edit</.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Regions")
     |> stream(:regions, Ash.read!(EduCount.Census.Region))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    region = Ash.get!(EduCount.Census.Region, id)
    # Ash.destroy!(region)

    {:noreply, stream_delete(socket, :regions, region)}
  end
end
