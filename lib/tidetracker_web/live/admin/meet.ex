defmodule TidetrackerWeb.Admin.MeetLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet
  alias Tidetracker.Meets.Team

  def render(assigns) do
    ~H"""
    <div class="mx-2 max-w-4xl sm:my-12 flex flex-col gap-y-12">
      <.simple_form for={@form} phx-submit="submit" phx-change="validate">
        <h2 class="font-serif font-bold text-2xl text-brand drop-shadow-lg"><%= @meet.description %></h2>
        <div>
          <.label for="name">Name (optional)</.label>
          <.input id="name" type="text" field={@form[:name]} />
        </div>

        <div>
          <.label for="date">Date</.label>
          <.input id="date" type="text" field={@form[:date]} placeholder="YYYY-MM-DD" />
        </div>

        <div>
          <.label>Teams</.label>
          <ul class="flex flex-col gap-y-2">
            <.inputs_for :let={team_form} field={@form[:teams]}>
              <div class="flex gap-x-2 items-center">
                <.card team={team_form.data} form={team_form} candidate_teams={@candidate_teams} />
                <.button type="button" phx-click="remove_form" phx-value-path={team_form.name} color={:caution}>
                  <.icon name="hero-trash" class="w-5 h-5" />
                </.button>
              </div>
            </.inputs_for>
          </ul>
          <.button type="button" class="mt-2" phx-click="add_form" phx-value-path={@form[:teams].name}>
            <.icon name="hero-plus" class="h-5 w-5" />
          </.button>
        </div>

        <:actions>
          <.button class="w-full max-w-sm">Save</.button>
        </:actions>
      </.simple_form>

      <.upload_heatsheet uploads={@uploads} />
      <.danger_zone />
    </div>
    """
  end

  defp card(assigns = %{team: %{id: nil}}) do
    ~H"""
    <.input type="select" field={@form[:id]} options={@candidate_teams} prompt="Select a team" />
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

  defp upload_heatsheet(assigns) do
    ~H"""
    <form
      id="upload-form"
      phx-submit="heatsheet_submit"
      phx-change="heatsheet_validate"
      phx-drop-target={@uploads.heatsheet.ref}
    >
      <div class="pb-5">
        <h3 class="text-base font-semibold leading-6 text-gray-100">Upload Heatsheet</h3>
        <p class="mt-2 max-w-4xl text-sm text-gray-500">
          Upload a CSV file exported from Meet Manager to load race and swimmer information for this meet.
        </p>
      </div>

      <.live_file_input upload={@uploads.heatsheet} />

      <.button type="submit" class="mt-2">
        <.icon name="hero-arrow-up-on-square" class="h-5 w-5" /> Submit
      </.button>
    </form>
    """
  end

  defp danger_zone(assigns) do
    ~H"""
    <div class="flex flex-col gap-2">
      <h3 class="text-base font-semibold leading-6 text-gray-100">Danger Zone</h3>
      <.button
        type="button"
        phx-click="delete_meet"
        color={:caution}
        data-confirm="This will delete the meet and all associated race and swimmer data. Are you sure?"
      >
        Delete Meet
      </.button>
    </div>
    """
  end

  def mount(params, _session, socket) do
    meet = Ash.get!(Meet, params["meet_id"])

    socket =
      socket
      |> assign(back_link: [patch: ~p"/admin"])
      |> set_meet(meet)
      |> assign(candidate_teams: Team.candidates_for_meet!(meet.id) |> Enum.map(&{&1.description, &1.id}))
      |> assign(new_team: nil)
      |> allow_upload(:heatsheet, accept: ~w(.csv), max_entries: 1, auto_upload: true, max_file_size: 100_000)

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
          |> set_meet(meet |> Ash.reload!())
          |> put_flash(:info, "Meet updated")

        {:error, form} ->
          assign(socket, form: form)
          |> put_flash(:error, "Error updating meet")
      end

    {:noreply, socket}
  end

  def handle_event("add_form", %{"path" => path}, socket) do
    form = AshPhoenix.Form.add_form(socket.assigns.form, path)
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("remove_form", %{"path" => path}, socket) do
    form = AshPhoenix.Form.remove_form(socket.assigns.form, path)
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("heatsheet_validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("heatsheet_submit", _params, socket) do
    [result] =
      consume_uploaded_entries(socket, :heatsheet, fn %{path: path}, _entry ->
        data = File.read!(path)
        {:ok, %{swimmers_found: 0, races_found: 0}}
      end)

    {:noreply, put_flash(socket, :info, "Swimmers found: #{result.swimmers_found}\nRaces found: #{result.races_found}")}
  end

  def handle_event("delete_meet", _params, socket) do
    Ash.destroy!(socket.assigns.meet)

    socket =
      socket
      |> put_flash(:info, "Meet deleted")
      |> push_navigate(to: ~p"/admin/meets")

    {:noreply, socket}
  end

  defp set_meet(socket, meet) do
    socket
    |> assign(meet: meet)
    |> assign(
      form:
        AshPhoenix.Form.for_update(meet, :update,
          forms: [
            teams: [
              type: :list,
              data: meet.teams,
              resource: Team,
              create_action: :update,
              update_action: :update
            ]
          ]
        )
        |> to_form()
    )
  end
end
