defmodule EduCountWeb.PageController do
  use EduCountWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
