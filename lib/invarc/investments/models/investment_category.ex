defmodule Invarc.Investments.Models.InvestmentCategory do
  @moduledoc "Investment category model"

  alias Invarc.Accounts.Models.Account
  alias Invarc.Investments.Models.{Investment, Transaction}

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "investment_categories" do
    field :name, :string

    # relationships
    belongs_to :account, Account, type: :binary_id

    has_many :transactions, Transaction, foreign_key: :category_id
    has_many :investments, Investment, foreign_key: :category_id

    timestamps()
  end
end
