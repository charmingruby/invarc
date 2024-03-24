defmodule Invarc.Investments.Model.Wallet do
  @moduledoc "Wallet model"

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name current_balance recorde_balance total_money_applied)a
  @required ~w(name current_balance recorde_balance total_money_applied)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "wallets" do
    field :name, :string
    field :current_balance, :integer
    field :record_balance, :integer
    field :total_money_applied, :integer

    # relationships

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
