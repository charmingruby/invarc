defmodule Invarc.Investments.Changesets.WalletChangesets do
  @moduledoc """
  Module to deal with wallets changeset validations
  """

  import Ecto.Changeset

  alias Invarc.Investments.Models.Wallet

  @fields ~w(name current_balance record_balance total_money_applied account_id)a
  @required ~w(name current_balance record_balance total_money_applied)a

  def build(%Wallet{} = wallet, params) do
    wallet
    |> cast(params, @fields)
    |> validate_required(@required)
    |> validate_rules()
  end

  defp validate_rules(changeset) do
    changeset
    |> validate_length(:name, min: 2, max: 16)
  end
end
