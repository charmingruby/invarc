defmodule Invarc.Investments.Model.Investment do
  @moduledoc "Investment model"

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name description source initial_value resultant_value)a
  @required ~w(name description source initial_value)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "investments" do
    field :name, :string
    field :description, :string
    field :source, :string
    field :initial_value, :integer
    field :resultant_value, :integer

    # relationships

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
