defmodule LISWeb.PersonController do
  use LISWeb, :controller

  def index(conn, _params) do
    new_person = get_session(conn, :newly_created_person)
    persons = LIS.Demographics.list_persons()

    conn
    |> delete_session(:newly_created_person)
    |> render(:index, persons: persons, new_person: new_person)
  end

  def new(conn, _params) do
    render(conn, :new, form: %{})
  end

  def create(conn, %{} = params) do
    case LIS.Demographics.create_person(params) do
      {:ok, %LIS.Demographics.Person{} = person} ->
        conn
        |> put_flash(:info, "Person created successfully.")
        |> put_session(:newly_created_person, person)
        |> redirect(to: ~p"/persons")

      _ ->
        conn
        |> put_flash(:error, "Failed to create person.")
        |> render(:new, form: params)
    end
  end
end
