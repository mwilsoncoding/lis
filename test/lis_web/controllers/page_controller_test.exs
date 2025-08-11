defmodule LISWeb.PageControllerTest do
  use LISWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 302)
    assert redirected_to(conn) == ~p"/persons/new"
  end
end
