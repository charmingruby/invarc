defmodule Invarc.Investments.Loaders.TransactionLoaders do
  @moduledoc """
  Module to execute transaction read queries
  """

  alias Invarc.{Investments.Loaders.Queries.TransactionQueries, Repo}

  def load_many_by_investment_id(id) do
    result =
      id
      |> TransactionQueries.many_by_investment_id()
      |> Repo.all()

    case result do
      nil -> {:error, :not_found}
      transactions -> {:ok, transactions}
    end
  end
end
