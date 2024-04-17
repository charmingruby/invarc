defmodule InvarcWeb.TransactionsJSON do
  alias InvarcWeb.Presenters.TransactionsPresenter

  def transaction_list(%{transactions: transactions}) do
    TransactionsPresenter.build_default_transaction_list(transactions)
  end
end
