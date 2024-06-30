defmodule TidetrackerWeb.Admin.MeetLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    ~H"""
    <div class="my-8 sm:my-20">
      <h2 class="font-serif font-bold text-2xl text-brand-lighter"><%= @meet.description %></h2>
      <.form :let={f} for={@form} phx-submit="save">
        <.label>Name (optional)</.label>
        <.input type="text" field={f[:name]} placeholder="Name" />
        <.button class="mt-2" type="submit">Save</.button>
      </.form>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(back_link: [patch: ~p"/admin"])
      |> set_meet(Ash.get!(Meet, params["meet_id"]))

    {:ok, socket}
  end

  def handle_event("save", %{"form" => form_params}, socket) do
    meet = socket.assigns.meet |> Meet.update!(form_params)
    {:noreply, set_meet(socket, meet)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp set_meet(socket, meet) do
    socket
    |> assign(meet: meet |> Ash.reload!())
    |> assign(form: AshPhoenix.Form.for_update(meet, :update) |> to_form())
  end
end
