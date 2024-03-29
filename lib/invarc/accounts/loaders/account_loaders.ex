defmodule Invarc.Accounts.Loaders.AccountLoaders do
  @moduledoc """
  Module to execute accounts read queries
  """

  alias Invarc.Accounts.Loaders.Queries.AccountQueries
  alias Invarc.Repo

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

  def one_by_id(id) do
    result =
      id
      |> AccountQueries.one_by_id()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end
end
