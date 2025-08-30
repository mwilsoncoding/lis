defmodule LISWeb.PersonLive.Show do
  use LISWeb, :live_view

  alias LIS.Demographics
  alias LISWeb.Components.Person

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Person {@person.id}
        <:subtitle>This is a person record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/persons"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.link patch={~p"/persons/#{@person}/show/edit"} phx-click={JS.push_focus()}>
            <.button variant="primary">
              <.icon name="hero-pencil-square" /> Edit person
            </.button>
          </.link>
        </:actions>
      </.header>

      <Person.details person={@person} title="Person" />

      <.modal
        :if={@live_action == :edit}
        id="person-modal"
        show
        on_cancel={JS.patch(~p"/persons/#{@person}")}
      >
        <.live_component
          module={LISWeb.PersonLive.FormComponent}
          current_scope={@current_scope}
          id={@person.id || :new}
          page_title={@page_title}
          live_action={@live_action}
          person={@person}
          patch={~p"/persons/#{@person}"}
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

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person, Demographics.get_person!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %LIS.Demographics.Person{id: id} = person},
        %{assigns: %{person: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :person, person)}
  end

  def handle_info(
        {:deleted, %LIS.Demographics.Person{id: id}},
        %{assigns: %{person: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current person was deleted.")
     |> push_navigate(to: ~p"/persons")}
  end

  def handle_info({type, %LIS.Demographics.Person{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Person"
  defp page_title(:edit), do: "Edit Person"
end
