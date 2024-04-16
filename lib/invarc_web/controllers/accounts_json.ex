defmodule InvarcWeb.AccountsJSON do
  alias InvarcWeb.Presenters.{AccountsPresenter, TransactionsPresenter}

  def account(%{account: account}) do
    AccountsPresenter.build_default_account(account)
  end

  def transaction_list(%{transactions: transactions}) do
    TransactionsPresenter.build_default_transaction_list(transactions)
  end
end
