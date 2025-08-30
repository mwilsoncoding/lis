defmodule LIS.DemographicsTest do
  use LIS.DataCase

  alias LIS.Demographics

  describe "persons" do
    alias LIS.Demographics.Person

    import LIS.AccountsFixtures, only: [user_scope_fixture: 0]
    import LIS.DemographicsFixtures

    @invalid_attrs %{name: nil, title: nil, age: nil, hometown: nil}

    test "list_persons/1 returns all scoped persons" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      person = person_fixture(scope)
      other_person = person_fixture(other_scope)
      assert Demographics.list_persons(scope) == [person]
      assert Demographics.list_persons(other_scope) == [other_person]
    end

    test "get_person!/2 returns the person with given id" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      other_scope = user_scope_fixture()
      assert Demographics.get_person!(scope, person.id) == person
      assert_raise Ecto.NoResultsError, fn -> Demographics.get_person!(other_scope, person.id) end
    end

    test "create_person/2 with valid data creates a person" do
      valid_attrs = %{name: "some name", title: "some title", age: 42, hometown: "some hometown"}
      scope = user_scope_fixture()

      assert {:ok, %Person{} = person} = Demographics.create_person(scope, valid_attrs)
      assert person.name == "some name"
      assert person.title == "some title"
      assert person.age == 42
      assert person.hometown == "some hometown"
      assert person.user_id == scope.user.id
    end

    test "create_person/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Demographics.create_person(scope, @invalid_attrs)
    end

    test "update_person/3 with valid data updates the person" do
      scope = user_scope_fixture()
      person = person_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        title: "some updated title",
        age: 43,
        hometown: "some updated hometown"
      }

      assert {:ok, %Person{} = person} = Demographics.update_person(scope, person, update_attrs)
      assert person.name == "some updated name"
      assert person.title == "some updated title"
      assert person.age == 43
      assert person.hometown == "some updated hometown"
    end

    test "update_person/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      person = person_fixture(scope)

      assert_raise MatchError, fn ->
        Demographics.update_person(other_scope, person, %{})
      end
    end

    test "update_person/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      person = person_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Demographics.update_person(scope, person, @invalid_attrs)

      assert person == Demographics.get_person!(scope, person.id)
    end

    test "delete_person/2 deletes the person" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert {:ok, %Person{}} = Demographics.delete_person(scope, person)
      assert_raise Ecto.NoResultsError, fn -> Demographics.get_person!(scope, person.id) end
    end

    test "delete_person/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      person = person_fixture(scope)
      assert_raise MatchError, fn -> Demographics.delete_person(other_scope, person) end
    end

    test "change_person/2 returns a person changeset" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert %Ecto.Changeset{} = Demographics.change_person(scope, person)
    end
  end
end
