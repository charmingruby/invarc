defmodule Invarc.Accounts.Loaders.AccountLoader do
  alias Invarc.Repo
  alias Invarc.Accounts.Loaders.Queries.AccountQueries

  def one_by_email(email) do
    result =
      email
      |> AccountQueries.one_by_email()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end
end
