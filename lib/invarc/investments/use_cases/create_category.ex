defmodule Invarc.Investments.UseCases.CreateCategory do
  @moduledoc """
  Create investment category use case
  """

  alias Invarc.Investments.Changesets.InvestmentCategoryChangesets
  alias Invarc.Investments.Loaders.CategoryLoaders
  alias Invarc.Investments.Models.InvestmentCategory
  alias Invarc.Investments.Mutators.CategoryMutators

  alias Invarc.Accounts.Loaders.AccountLoaders

  alias Invarc.Common.UseCases.Errors

  def call(%{account_id: account_id} = params) do
    case AccountLoaders.load_one_by_id(account_id) do
      {:ok, _} -> verify_if_category_already_exists(params)
      {:error, :not_found} -> Errors.wrap_not_found_error("account_id")
    end
  end

  defp verify_if_category_already_exists(params) do
    case CategoryLoaders.load_one_by_name_and_account_id(params) do
      {:ok, _} -> Errors.wrap_conflict_error("name")
      {:error, :not_found} -> handle_create_category_for_account(params)
    end
  end

  defp handle_create_category_for_account(params) do
    %InvestmentCategory{}
    |> InvestmentCategoryChangesets.build(params)
    |> CategoryMutators.create()
  end
end
