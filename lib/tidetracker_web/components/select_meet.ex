defmodule TidetrackerWeb.Components.SelectMeet do
  use Phoenix.Component
  alias TidetrackerWeb.Components.ComboBox

  @meets [
    {1, "Meet 1", ~D"2024-06-01"}
  ]

  attr :meets, :list, default: @meets
  attr :label_class, :string, default: "text-white"

  def select_meet(assigns) do
    ~H"""
    <ComboBox.combo_box label="Select a meet" name="select-meet" items={@meets} label_class={@label_class} />
    """
  end
end
