defmodule LIS.DemographicsTest do
  use LIS.DataCase

  alias LIS.Demographics

  describe "persons" do
    alias LIS.Demographics.Person

    import LIS.DemographicsFixtures

    @invalid_attrs %{name: nil, title: nil, age: nil, hometown: nil}

    test "list_persons/0 returns all persons" do
      person = person_fixture()
      assert Demographics.list_persons() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Demographics.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{name: "some name", title: "some title", age: 42, hometown: "some hometown"}

      assert {:ok, %Person{} = person} = Demographics.create_person(valid_attrs)
      assert person.name == "some name"
      assert person.title == "some title"
      assert person.age == 42
      assert person.hometown == "some hometown"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Demographics.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()

      update_attrs = %{
        name: "some updated name",
        title: "some updated title",
        age: 43,
        hometown: "some updated hometown"
      }

      assert {:ok, %Person{} = person} = Demographics.update_person(person, update_attrs)
      assert person.name == "some updated name"
      assert person.title == "some updated title"
      assert person.age == 43
      assert person.hometown == "some updated hometown"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Demographics.update_person(person, @invalid_attrs)
      assert person == Demographics.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Demographics.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Demographics.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Demographics.change_person(person)
    end
  end
end
