defmodule Invarc.Investments.Models.Transaction do
  @moduledoc "Transaction model"

  alias Invarc.Accounts.Models.Account

  alias Invarc.Investments.Models.{
    Investment,
    InvestmentCategory,
    Wallet
  }

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transactions" do
    field :name, :string
    field :amount, :integer
    field :status, :string
    field :type, :string

    # relationships
    belongs_to :wallet, Wallet, type: :binary_id
    belongs_to :investment, Investment, type: :binary_id
    belongs_to :category, InvestmentCategory, type: :binary_id
    belongs_to :account, Account, type: :binary_id

    timestamps()
  end
end
