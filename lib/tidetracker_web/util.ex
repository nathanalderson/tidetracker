defmodule TidetrackerWeb.Utils do
  def orange_gradient(), do: "from-[#ff0d0d] to-[#ff810d]"
  def brand_gradient(), do: "from-brand-darker to-brand"

  def orange_bg_gradient(), do: "bg-gradient-to-r #{orange_gradient()}"
  def brand_bg_gradient(), do: "bg-gradient-to-r #{brand_gradient()}"
end
