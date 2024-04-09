defmodule Invarc.Accounts.UseCases.Authenticate do
  @moduledoc """
  Authentication use case
  """
  alias Invarc.{Accounts.Loaders.AccountLoaders, Common.Security}

  def call(params) do
    with {:ok, account} <- verify_if_account_exists(params) do
      authenticate(params, account)
    end
  end

  defp verify_if_account_exists(%{email: email}) do
    case AccountLoaders.load_one_by_email(email) do
      {:ok, account} -> {:ok, account}
      {:error, :not_found} -> {:error, :invalid_credentials}
    end
  end

  defp authenticate(%{password: password}, account) do
    case Security.verify_hash(password, account.password_hash) do
      false -> {:error, :invalid_credentials}
      true -> {:ok, account}
    end
  end
end
