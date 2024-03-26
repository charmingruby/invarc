defmodule Invarc.Investments.Models.Wallet do
  @moduledoc "Wallet model"

  alias Invarc.Accounts.Models.Account

  alias Invarc.Investments.Models.{
    Investment,
    Transaction
  }

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
