defmodule TidetrackerWeb.Admin.MeetLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    dbg(assigns.form.errors)

    ~H"""
    <div class="mx-2 my-8 sm:my-20">
      <h2 class="font-serif font-bold text-2xl text-brand-lighter"><%= @meet.description %></h2>
      <.simple_form for={@form} phx-submit="submit" phx-change="validate">
        <.label>Name (optional)</.label>
        <.input type="text" field={@form[:name]} placeholder="Name" />

        <.label>Date</.label>
        <.input type="text" field={@form[:date]} placeholder="YYYY-MM-DD" />

        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(params, _session, socket) do
    meet = Ash.get!(Meet, params["meet_id"])

    socket =
      socket
      |> assign(back_link: [patch: ~p"/admin"])
      |> assign(meet: meet)
      |> assign(form: AshPhoenix.Form.for_update(meet, :update) |> to_form())

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("submit", params, socket) do
    socket =
      case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
        {:ok, meet} ->
          socket
          |> assign(meet: meet |> Ash.reload!())
          |> put_flash(:info, "Meet updated")

        {:error, form} ->
          assign(socket, form: form)
      end

    {:noreply, socket}
  end
end
