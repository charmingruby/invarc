defmodule Invarc.Accounts.Models.Account do
  @moduledoc "Account model"

  alias Invarc.Common.Security
  alias Invarc.Investments.Models.{InvestmentCategory, Wallet}

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name email password role plan)a
  @required ~w(name email password)a

  @valid_roles ~w(member manager)
  @valid_plans ~w(free premium)

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

    timestamps()
  end

  def changeset(%__MODULE__{} = account, params) do
    account
    |> cast(params, @fields)
    |> validate_required(@required)
    |> unique_constraint(:email)
    |> validate_rules()
  end

  defp validate_rules(changeset) do
    changeset
    |> validate_length(:name, min: 3, max: 32)
    |> validate_format(:email, ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/)
    |> validate_length(:password, min: 8, max: 16)
    |> validate_inclusion(:plan, @valid_plans)
    |> validate_inclusion(:role, @valid_roles)
  end

  def hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Security.hash(password))
  end

  def hash_password(changeset), do: changeset
end
