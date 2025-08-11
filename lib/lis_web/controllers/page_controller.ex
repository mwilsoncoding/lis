defmodule LISWeb.PageController do
  use LISWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
