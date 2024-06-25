defmodule TidetrackerWeb.Components.ComboBox do
  use TidetrackerWeb, :component

  attr :label, :string, required: true
  attr :items, :list, required: true
  attr :selected, :any, default: nil
  attr :name, :string
  attr :id, :string, default: nil
  attr :class, :string, default: "flex flex-col gap-y-1"
  attr :label_class, :string, default: "text-white"

  def combo_box(assigns) do
    ~H"""
    <div class={@class}>
      <label class={@label_class} for={@id || @name}><%= @label %></label>
      <select id={@id || @name} name={@name} class="rounded-lg text-sm bg-gray-800 text-white">
        <option :for={{value, title, secondary} <- @items} value={value} class="text-sm" selected={value == @selected}>
          <%= title %> (<%= secondary %>)
        </option>
      </select>
    </div>
    """
  end
end
