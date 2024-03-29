defmodule Invarc.Investments.Loaders.WalletLoaders do
  @moduledoc """
  Module to execute wallets read queries
  """
  alias Invarc.{Investments.Loaders.Queries.WalletQueries, Repo}

  def one_by_name_in_wallet(params) do
    result =
      params
      |> WalletQueries.one_by_name_of_an_account()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      wallet -> {:ok, wallet}
    end
  end
end
