defmodule InvarcWeb.Presenters.AccountsPresenter do
  @moduledoc """
  Module that handles with how accounts will be represented on the responses
  """

  def build_default_account(account) do
    %{
      id: account.id,
      name: account.name,
      email: account.email,
      role: account.role,
      plan: account.plan,
      inserted_at: account.inserted_at,
      updated_at: account.updated_at
    }
  end
end
