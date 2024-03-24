defmodule Invarc.Investments.Model.Transaction do
  @moduledoc "Transaction model"

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name amount status type)a
  @required ~w(name amount status type)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transactions" do
    field :name, :string
    field :amount, :integer
    field :status, :string
    field :type, :string

    # relationships

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
