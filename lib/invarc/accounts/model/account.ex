defmodule Invarc.Accounts.Model.Account do
  @moduledoc "Account model"

  alias Invarc.Accounts.Model.Account
  alias Invarc.Investments.Model.{InvestmentCategory, Wallet}

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name email password role plan)a
  @required ~w(name email password)a

  @valid_roles ~w(member manager)
  @valid_plans ~w(free premium)

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "account" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :role, :string
    field :plan, :string

    # relationships
    has_many :wallets, Wallet
    has_many :investment_categories, InvestmentCategory

    timestamps()
  end

  def changeset(%Account{} = account, params) do
    account
    |> cast(params, @fields)
    |> validate_required(@required)
    |> unique_constraint(:email)
    |> validate_rules()
  end

  defp validate_rules(changeset) do
    changeset
    |> validate_inclusion(:plan, @valid_plans)
    |> validate_inclusion(:role, @valid_roles)
  end
end
