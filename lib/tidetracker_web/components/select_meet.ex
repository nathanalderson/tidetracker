defmodule TidetrackerWeb.Components.SelectMeet do
  use TidetrackerWeb, :component

  @meets [
    {1, "Meet 1", ~D"2024-06-01"},
    {2, "Meet 2", ~D"2024-06-02"},
    {3, "Meet 3", ~D"2024-06-03"}
  ]

  attr :meets, :list, default: @meets
  attr :label_class, :string, default: "text-white"

  def select_meet(assigns) do
    ~H"""
    <Components.ComboBox.combo_box label="Select a meet" name="select-meet" items={@meets} label_class={@label_class} />
    """
  end
end
