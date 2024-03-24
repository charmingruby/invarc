defmodule Invarc.Investments.Model.InvestmentCategory do
  @moduledoc "Investment category model"

  alias Invarc.Accounts.Model.Account
  alias Invarc.Investments.Model.{Investment, Transaction}

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name)a
  @required ~w(name)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "investment_category" do
    field :name, :string

    # relationships
    belongs_to :account, Account, type: :binary_id

    has_many :transactions, Transaction, foreign_key: :category_id
    has_many :investments, Investment, foreign_key: :category_id

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
