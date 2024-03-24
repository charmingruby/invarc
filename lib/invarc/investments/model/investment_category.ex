defmodule Invarc.Investments.Model.InvestmentCategory do
  @moduledoc "Investment category model"

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name)a
  @required ~w(name)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "investment_categories" do
    field :name, :string

    # relationships

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
