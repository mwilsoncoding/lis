defmodule LIS.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :name, :string
      add :age, :integer
      add :title, :string
      add :hometown, :string

      timestamps(type: :utc_datetime)
    end
  end
end
