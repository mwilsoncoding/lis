defmodule LIS.Demographics.Person do
  @moduledoc """
  This module defines the Person schema and changesets.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "persons" do
    field :name, :string
    field :age, :integer
    field :title, :string
    field :hometown, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(person, attrs, user_scope) do
    person
    |> cast(attrs, [:name, :age, :title, :hometown])
    |> validate_required([:name, :title])
    |> put_change(:user_id, user_scope.user.id)
  end
end
