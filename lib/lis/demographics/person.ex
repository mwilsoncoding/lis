defmodule LIS.Demographics.Person do
  @moduledoc """
  Represents a person in the system.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "persons" do
    field :name, :string
    field :age, :integer
    field :title, :string
    field :hometown, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :age, :title, :hometown])
    |> validate_required([:name, :title])
  end
end
