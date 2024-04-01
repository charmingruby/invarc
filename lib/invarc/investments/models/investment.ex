defmodule Invarc.Investments.Models.Investment do
  @moduledoc "Investment model"

  alias Invarc.Investments.Models.{InvestmentCategory, Transaction, Wallet}

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "investments" do
    field :name, :string
    field :description, :string
    field :source, :string
    field :initial_value, :integer, default: 0
    field :resultant_value, :integer, default: 0

    # relationships
    belongs_to :category, InvestmentCategory, type: :binary_id
    belongs_to :wallet, Wallet, type: :binary_id

    has_many :transactions, Transaction

    timestamps()
  end
end
