defmodule LISWeb.PersonLive.FormComponent do
  use LISWeb, :live_component

  alias LIS.Demographics
  alias LISWeb.Components.Person, as: PersonComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="person-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <PersonComponent.inputs form={@form} />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Person</.button>
        </footer>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset = Demographics.change_person(assigns.current_scope, assigns.person, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      Demographics.change_person(
        socket.assigns.current_scope,
        socket.assigns.person,
        person_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.live_action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case Demographics.update_person(
           socket.assigns.current_scope,
           socket.assigns.person,
           person_params
         ) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_person(socket, :new, person_params) do
    case Demographics.create_person(socket.assigns.current_scope, person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
