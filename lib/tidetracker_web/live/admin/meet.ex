defmodule TidetrackerWeb.Admin.MeetLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    dbg(assigns.form.errors)

    ~H"""
    <div class="mx-2 my-12 sm:my-20">
      <h2 class="font-serif font-bold text-2xl text-brand drop-shadow-lg"><%= @meet.description %></h2>
      <.simple_form for={@form} phx-submit="submit" phx-change="validate">
        <div>
          <.label for="name">Name (optional)</.label>
          <.input id="name" type="text" field={@form[:name]} placeholder="Name" />
        </div>

        <div>
          <.label for="date">Date</.label>
          <.input id="date" type="text" field={@form[:date]} placeholder="YYYY-MM-DD" />
        </div>

        <div>
          <.label>Teams</.label>
          <ul class="flex flex-col gap-y-2">
            <.card :for={team <- @meet.teams} team={team} />
          </ul>
        </div>

        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp card(assigns) do
    ~H"""
    <li class={[
      "block cursor-default w-full rounded-md bg-white/5 pl-1 pr-3 py-1.5 text-white shadow-sm border-1 border-white/10 sm:text-sm sm:leading-6",
      border_classes(@team)
    ]}>
      <%= @team.description %>
    </li>
    """
  end

  defp border_classes(_team) do
    "border border-1 border-white/5 border-l-brand border-l-8"
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

  def handle_event("submit", %{"form" => params}, socket) do
    socket =
      case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
        {:ok, meet} ->
          socket
          |> assign(meet: meet |> Ash.reload!())
          |> put_flash(:info, "Meet updated")

        {:error, form} ->
          assign(socket, form: form)
          |> put_flash(:error, "Error updating meet")
      end

    {:noreply, socket}
  end
end
