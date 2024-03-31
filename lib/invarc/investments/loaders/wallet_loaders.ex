defmodule Invarc.Investments.Loaders.WalletLoaders do
  @moduledoc """
  Module to execute wallets read queries
  """
  alias Invarc.{Investments.Loaders.Queries.WalletQueries, Repo}

  def load_one_by_id(id) do
    result =
      id
      |> WalletQueries.one_by_id()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      wallet -> {:ok, wallet}
    end
  end

  def load_one_by_name_and_account_id(params) do
    result =
      params
      |> WalletQueries.one_by_name_and_account_id()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      wallet -> {:ok, wallet}
    end
  end
end
