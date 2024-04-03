defmodule Invarc.Investments.Loaders.InvestmentLoaders do
  @moduledoc """
  Module to execute investment  read queries
  """

  alias Invarc.{Investments.Loaders.Queries.InvestmentQueries, Repo}

  def load_one_by_name_and_wallet_id(params) do
    result =
      params
      |> InvestmentQueries.one_by_name_and_wallet_id()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      investment -> {:ok, investment}
    end
  end

  def load_one_by_id(id) do
    result =
      id
      |> InvestmentQueries.one_by_id()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      investment -> {:ok, investment}
    end
  end
end
