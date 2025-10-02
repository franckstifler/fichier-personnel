defmodule EduCountWeb.SubDivisionLive.Index do
  use EduCountWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {gettext("Listing Sub divisions")}
        <:actions>
          <.button variant="primary" navigate={~p"/config/sub_divisions/new"}>
            <.icon name="hero-plus" /> {gettext("New Sub division")}
          </.button>
        </:actions>
      </.header>

      <.table
        id="sub_divisions"
        rows={@streams.sub_divisions}
        row_click={
          fn {_id, sub_division} -> JS.navigate(~p"/config/sub_divisions/#{sub_division}") end
        }
      >
        <:col :let={{_id, sub_division}} label="Name">{sub_division.name}</:col>
        <:col :let={{_id, sub_division}} label="Name">{sub_division.division.name}</:col>
        <:col :let={{_id, sub_division}} label="Name">{sub_division.division.region.name}</:col>

        <:action :let={{_id, sub_division}}>
          <div class="sr-only">
            <.link navigate={~p"/config/sub_divisions/#{sub_division}"}>{gettext("Show")}</.link>
          </div>

          <.link navigate={~p"/config/sub_divisions/#{sub_division}/edit"}>{gettext("Edit")}</.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Listing Sub divisions"))
     |> stream(
       :sub_divisions,
       Ash.read!(EduCount.Census.SubDivision, load: [division: :region]),
       dom_id: &"sub_division-#{&1.id}"
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sub_division = Ash.get!(EduCount.Census.SubDivision, id)
    # Ash.destroy!(sub_division)

    {:noreply, stream_delete(socket, :sub_divisions, sub_division)}
  end
end
