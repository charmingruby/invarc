defmodule Invarc.Investments.Loaders.CategoryLoaders do
  @moduledoc """
  Module to execute investment categories read queries
  """

  alias Invarc.{Investments.Loaders.Queries.CategoryQueries, Repo}

  def load_one_by_name_and_account_id(params) do
    result =
      params
      |> CategoryQueries.one_by_name_and_account_id()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      category -> {:ok, category}
    end
  end

  def load_one_by_id(id) do
    result =
      id
      |> CategoryQueries.one_by_id()
      |> Repo.one()

    case result do
      nil -> {:error, :not_found}
      category -> {:ok, category}
    end
  end
end
