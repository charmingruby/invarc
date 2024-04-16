defmodule Invarc.Accounts.Models.Account do
  @moduledoc "Account model"

  alias Invarc.Investments.Models.{InvestmentCategory, Transaction, Wallet}

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "accounts" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :string
    field :plan, :string

    # relationships
    has_many :wallets, Wallet
    has_many :investment_categories, InvestmentCategory
    has_many :transactions, Transaction

    timestamps()
  end
end
