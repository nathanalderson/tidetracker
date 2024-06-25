defmodule TidetrackerWeb.Components.SelectMeet do
  use TidetrackerWeb, :component
  alias Tidetracker.Meets.Meet

  attr :meets, :list, required: true
  attr :selected, Meet, default: nil
  attr :label_class, :string, default: "text-white"

  def select_meet(assigns) do
    ~H"""
    <Components.ComboBox.combo_box
      event="select_meet"
      label="Select a meet"
      name="select-meet"
      items={to_items(@meets)}
      selected={@selected.id}
      label_class={@label_class}
    />
    """
  end

  defp to_items(meets) do
    for meet <- meets do
      {meet.id, meet.description, meet.date |> Timex.format!("{Mshort} {D}, {YYYY}")}
    end
  end
end
