defmodule InvarcWeb.AccountsJSON do
  alias InvarcWeb.Presenters.AccountsPresenter

  def account(%{account: account}) do
    AccountsPresenter.build_default_account(account)
  end
end
