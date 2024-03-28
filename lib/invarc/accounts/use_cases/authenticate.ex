defmodule Invarc.Accounts.UseCases.Authenticate do
  @moduledoc """
  Authentication use case
  """

  alias Invarc.{Accounts.Loaders.AccountLoader, Common.Security}

  def call(%{email: email, password: password}) do
    case AccountLoader.one_by_email(email) do
      {:error, :not_found} = err -> err
      {:ok, account} -> handle_verify_account_credentials(%{account: account, password: password})
    end
  end

  defp handle_verify_account_credentials(%{account: account, password: password}) do
    case Security.verify_hash(password, account.password_hash) do
      false -> {:error, :invalid_credentials}
      true -> {:ok, account}
    end
  end
end
