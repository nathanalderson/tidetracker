defmodule TidetrackerWeb.ErrorJSONTest do
  use TidetrackerWeb.ConnCase, async: true

  test "renders 404" do
    assert TidetrackerWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert TidetrackerWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
