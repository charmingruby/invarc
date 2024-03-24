defmodule Invarc.Investments.Model.Wallet do
  @moduledoc "Wallet model"

  alias Invarc.Investments.Model.{
    Investment,
    Transaction
  }

  alias Invarc.Accounts.Model.Account

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name current_balance recorde_balance total_money_applied)a
  @required ~w(name current_balance recorde_balance total_money_applied)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "wallet" do
    field :name, :string
    field :current_balance, :integer
    field :record_balance, :integer
    field :total_money_applied, :integer

    # relationships
    belongs_to :account, Account, type: :binary_id

    has_many :transactions, Transaction
    has_many :investments, Investment

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
