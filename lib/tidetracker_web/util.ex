defmodule TidetrackerWeb.Utils do
  def orange_gradient(), do: "from-[#ff0d0d] to-[#ff810d]"
  def orange_gradient_hover(), do: "hover:from-[#ff0d0d]/8 hover:to-[#ff810d]/8"

  def brand_gradient(), do: "from-brand-darker to-brand"
  def brand_gradient_hover(), do: "hover:from-brand-darker/8 hover:to-brand/8"

  def orange_bg_gradient(), do: "bg-gradient-to-r #{orange_gradient()}"
  def brand_bg_gradient(), do: "bg-gradient-to-r #{brand_gradient()}"
end
