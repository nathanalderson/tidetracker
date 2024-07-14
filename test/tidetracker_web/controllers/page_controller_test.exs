defmodule TidetrackerWeb.PageControllerTest do
  use TidetrackerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    resp = assert html_response(conn, 200)
    assert resp =~ "Tidetracker"
    assert resp =~ "Select a meet"
  end
end
