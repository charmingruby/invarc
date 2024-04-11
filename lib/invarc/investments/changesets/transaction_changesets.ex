defmodule Invarc.Investments.Changesets.TransactionChangesets do
  @moduledoc """
  Module to deal with transactions changeset validations
  """

  alias Invarc.Investments.Models.Transaction

  import Ecto.Changeset

  @fields ~w(name amount status type wallet_id investment_id category_id)a
  @required ~w(name amount status type wallet_id investment_id category_id)a

  @valid_status ~w(success rollback failure)
  @valid_types ~w(income outcome)

  def build(%Transaction{} = transaction, params) do
    transaction
    |> cast(params, @fields)
    |> validate_required(@required)
    |> validate_rules()
  end

  defp validate_rules(changeset) do
    changeset
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:status, @valid_status)
    |> validate_inclusion(:type, @valid_types)
  end

  def build_transaction_name(%{wallet_name: wallet_name, type: type}) do
    "#{wallet_name}_#{type}_#{DateTime.utc_now()}"
  end
end
