defmodule LISWeb.PageController do
  use LISWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/persons/new")
  end
end
