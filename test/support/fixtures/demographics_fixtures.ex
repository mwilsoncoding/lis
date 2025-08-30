defmodule LIS.DemographicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LIS.Demographics` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        age: 42,
        hometown: "some hometown",
        name: "some name",
        title: "some title"
      })

    {:ok, person} = LIS.Demographics.create_person(scope, attrs)
    person
  end
end
