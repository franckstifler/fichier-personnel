defmodule EduCountWeb.DivisionLive.Index do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {gettext("Listing Divisions")}
        <:actions>
          <.button variant="primary" navigate={~p"/admin/divisions/new"}>
            <.icon name="hero-plus" /> {gettext("New Division")}
          </.button>
        </:actions>
      </.header>

      <.table
        id="divisions"
        rows={@streams.divisions}
        row_click={fn {_id, division} -> JS.navigate(~p"/admin/divisions/#{division}") end}
      >
        <:col :let={{_id, division}} label="Name">{division.name}</:col>
        <:col :let={{_id, division}} label="Name">{division.region.name}</:col>

        <:action :let={{_id, division}}>
          <div class="sr-only">
            <.link navigate={~p"/admin/divisions/#{division}"}>{gettext("Show")}</.link>
          </div>

          <.link navigate={~p"/admin/divisions/#{division}/edit"}>{gettext("Edit")}</.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Listing Divisions"))
     |> stream(:divisions, Ash.read!(EduCount.Census.Division, load: [:region]))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    division = Ash.get!(EduCount.Census.Division, id)
    # Ash.destroy!(division)

    {:noreply, stream_delete(socket, :divisions, division)}
  end
end
