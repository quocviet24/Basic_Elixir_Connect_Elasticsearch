defmodule TestConnectElastic.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do
    field :name, :string
    field :age, :integer

    timestamps()
  end

  def changeset(student, attrs) do
    student
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
