defmodule Invarc.Investments.Models.Wallet do
  @moduledoc "Wallet model"

  alias Invarc.Accounts.Models.Account

  alias Invarc.Investments.Models.{
    Investment,
    Transaction
  }

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "wallets" do
    field :name, :string
    field :current_balance, :integer, default: 0
    field :record_balance, :integer, default: 0
    field :total_money_applied, :integer, default: 0

    # relationships
    belongs_to :account, Account, type: :binary_id

    has_many :transactions, Transaction
    has_many :investments, Investment

    timestamps()
  end
end
