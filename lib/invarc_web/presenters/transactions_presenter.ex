defmodule InvarcWeb.Presenters.TransactionsPresenter do
  @moduledoc """
  Module that handles with how transactions will be represented on the responses
  """

  def build_default_transaction(transaction) do
    %{
      id: transaction.id,
      name: transaction.name,
      amount: transaction.amount,
      status: transaction.status,
      type: transaction.type,
      wallet_id: transaction.wallet_id,
      investment_id: transaction.investment_id,
      category_id: transaction.category_id,
      account_id: transaction.account_id,
      inserted_at: transaction.inserted_at,
      updated_at: transaction.updated_at
    }
  end

  def build_default_transaction_list(transactions) do
    Enum.map(transactions, &build_default_transaction/1)
  end
end
