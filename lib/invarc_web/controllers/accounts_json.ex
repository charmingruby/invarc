defmodule InvarcWeb.AccountsJSON do
  def account(%{account: account}) do
    build_account_data(account)
  end

  defp build_account_data(account) do
    IO.inspect(account)
  end
end
