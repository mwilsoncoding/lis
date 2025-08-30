defmodule LISWeb.PersonLive.Index do
  use LISWeb, :live_view

  alias LIS.Demographics
  alias LIS.Demographics.Person

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Persons
        <:actions>
          <.link patch={~p"/persons/new"}>
            <.button variant="primary">
              <.icon name="hero-plus" /> New Person
            </.button>
          </.link>
        </:actions>
      </.header>

      <div :if={@new_person}>
        <.header>
          <LISWeb.Components.Person.details person={@new_person} title="New Person" />
        </.header>
      </div>

      <.table
        id="persons"
        rows={@streams.persons}
        row_click={fn {_id, person} -> JS.navigate(~p"/persons/#{person}") end}
      >
        <:col :let={{_id, person}} label="Name">{person.name}</:col>
        <:col :let={{_id, person}} label="Age">{person.age}</:col>
        <:col :let={{_id, person}} label="Title">{person.title}</:col>
        <:col :let={{_id, person}} label="Hometown">{person.hometown}</:col>
        <:action :let={{_id, person}}>
          <div class="sr-only">
            <.link patch={~p"/persons/#{person}"}>Show</.link>
          </div>
          <.link patch={~p"/persons/#{person}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, person}}>
          <.link
            phx-click={JS.push("delete", value: %{id: person.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>

      <.modal
        :if={@live_action in [:new, :edit]}
        id="person-modal"
        show
        on_cancel={JS.patch(~p"/persons")}
      >
        <.live_component
          module={LISWeb.PersonLive.FormComponent}
          current_scope={@current_scope}
          id={@person.id || :new}
          page_title={@page_title}
          live_action={@live_action}
          person={@person}
          patch={~p"/persons"}
        />
      </.modal>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Demographics.subscribe_persons(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:new_person, nil)
     |> stream(:persons, Demographics.list_persons(socket.assigns.current_scope))}
  end

  @impl true
  def handle_params(unsigned_params, _uri, socket) do
    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, unsigned_params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Persons")
    |> assign(:person, nil)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    person = Demographics.get_person!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, person)
  end

  defp apply_action(socket, :new, _params) do
    person = %Person{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, person)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Demographics.get_person!(socket.assigns.current_scope, id)
    {:ok, _} = Demographics.delete_person(socket.assigns.current_scope, person)

    {:noreply,
     socket
     |> maybe_delete_new_person(id)
     |> stream_delete(:persons, person)}
  end

  defp maybe_delete_new_person(%{assigns: %{new_person: %{id: id}}} = socket, id) do
    socket
    |> assign(:new_person, nil)
  end

  defp maybe_delete_new_person(socket, _id), do: socket

  @impl true
  def handle_info({type, %LIS.Demographics.Person{} = person}, socket)
      when type == :created do
    {:noreply,
     socket
     |> assign(:new_person, person)
     |> reset_stream()}
  end

  def handle_info({type, %LIS.Demographics.Person{} = person}, socket)
      when type == :deleted do
    {:noreply,
     socket
     |> maybe_delete_new_person(person.id)
     |> reset_stream()}
  end

  def handle_info({type, %LIS.Demographics.Person{}}, socket)
      when type == :updated do
    {:noreply, reset_stream(socket)}
  end

  defp reset_stream(socket) do
    stream(socket, :persons, Demographics.list_persons(socket.assigns.current_scope), reset: true)
  end
end
