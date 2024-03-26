defmodule Invarc.Accounts.Changesets.AccountChangesets do
  alias Invarc.Accounts.Models.Account
  alias Invarc.Common.Security

  import Ecto.Changeset

  @fields ~w(name email password role plan)a
  @required ~w(name email password)a

  @valid_roles ~w(member manager)
  @valid_plans ~w(free premium)

  def build(%Account{} = account, params) do
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
