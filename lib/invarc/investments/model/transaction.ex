defmodule Invarc.Investments.Model.Transaction do
  @moduledoc "Transaction model"

  alias Invarc.Investments.Model.{
    Investment,
    InvestmentCategory,
    Wallet
  }

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name amount status type wallet_receiver_id wallet_sender_id)a
  @required ~w(name amount status type)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transaction" do
    field :name, :string
    field :amount, :integer
    field :status, :string
    field :type, :string

    # relationships
    belongs_to :wallet, Wallet, type: :binary_id
    belongs_to :investment, Investment, type: :binary_id
    belongs_to :category, InvestmentCategory, type: :binary_id

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
