defmodule Invarc.Investments.Changesets.WalletChangesets do
  @moduledoc """
  Module to deal with wallets changeset validations
  """

  import Ecto.Changeset

  alias Invarc.Investments.Models.Wallet

  @fields ~w(name funds_applied funds_received account_id)a
  @required ~w(name account_id)a

  def build(%Wallet{} = wallet, params) do
    wallet
    |> cast(params, @fields)
    |> validate_required(@required)
    |> validate_rules()
  end

  defp validate_rules(changeset) do
    changeset
    |> validate_length(:name, min: 2, max: 32)
  end
end
