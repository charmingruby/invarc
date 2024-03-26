defmodule InvarcWeb.AccountsJSON do
  def account(%{account: account}) do
    build_account_data(account)
  end

  defp build_account_data(account) do
    %{
      id: account.id,
      name: account.name,
      email: account.email,
      password_hash: account.password_hash,
      role: account.role,
      plan: account.plan,
      inserted_at: account.inserted_at,
      updated_at: account.updated_at
    }
  end
end
