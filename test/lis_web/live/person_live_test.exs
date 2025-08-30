defmodule LISWeb.PersonLiveTest do
  use LISWeb.ConnCase

  import Phoenix.LiveViewTest
  import LIS.DemographicsFixtures

  @create_attrs %{name: "some name", title: "some title", age: 42, hometown: "some hometown"}
  @update_attrs %{
    name: "some updated name",
    title: "some updated title",
    age: 43,
    hometown: "some updated hometown"
  }
  @invalid_attrs %{name: nil, title: nil, age: nil, hometown: nil}

  setup :register_and_log_in_user

  defp create_person(%{scope: scope}) do
    person = person_fixture(scope)

    %{person: person}
  end

  describe "Index" do
    setup [:create_person]

    test "lists all persons", %{conn: conn, person: person} do
      {:ok, _index_live, html} = live(conn, ~p"/persons")

      assert html =~ "Listing Persons"
      assert html =~ person.name
    end

    test "saves new person", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      modal =
        index_live
        |> element("a", "New Person")
        |> render_click()

      assert modal =~ "New Person"

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      html =
        index_live
        |> form("#person-form", person: @create_attrs)
        |> render_submit()

      assert html =~ "Person created successfully"
      assert html =~ "some name"
    end

    test "updates person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      refute index_live
             |> element("#person-modal")
             |> has_element?()

      _ =
        index_live
        |> element("#persons-#{person.id} a", "Edit")
        |> render_click()

      assert index_live
             |> element("#person-modal")
             |> has_element?()

      assert_patch index_live, ~p"/persons/#{person.id}/edit"

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      _ =
        index_live
        |> form("#person-form", person: @update_attrs)
        |> render_submit()

      assert_patch index_live, ~p"/persons"

      html = render(index_live)

      assert html =~ "Person updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      assert index_live |> element("#persons-#{person.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#persons-#{person.id}")
    end
  end

  describe "Show" do
    setup [:create_person]

    test "displays person", %{conn: conn, person: person} do
      {:ok, _show_live, html} = live(conn, ~p"/persons/#{person}")

      assert html =~ "Show Person"
      assert html =~ person.name
    end

    test "updates person and returns to show", %{conn: conn, person: person} do
      {:ok, show_live, _html} = live(conn, ~p"/persons/#{person}")

      refute show_live
             |> element("#person-modal")
             |> has_element?()

      _ =
        show_live
        |> element("a", "Edit")
        |> render_click()

      assert show_live
             |> element("#person-modal")
             |> has_element?()

      assert_patch show_live, ~p"/persons/#{person.id}/show/edit"

      assert show_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      _ =
        show_live
        |> form("#person-form", person: @update_attrs)
        |> render_submit()

      assert_patch show_live, ~p"/persons/#{person.id}"

      html = render(show_live)

      assert html =~ "Person updated successfully"
      assert html =~ "some updated name"
    end
  end
end
