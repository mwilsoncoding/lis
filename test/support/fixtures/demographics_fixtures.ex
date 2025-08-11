defmodule LIS.DemographicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LIS.Demographics` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        age: 42,
        hometown: "some hometown",
        name: "some name",
        title: "some title"
      })
      |> LIS.Demographics.create_person()

    person
  end
end
