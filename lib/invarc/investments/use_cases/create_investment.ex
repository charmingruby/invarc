defmodule Invarc.Investments.UseCases.CreateInvestment do
  @moduledoc """
  Create investment use case
  """

  alias Invarc.Common.UseCases.Errors
  alias Invarc.Investments.Changesets.InvestmentChangesets
  alias Invarc.Investments.Loaders.{CategoryLoaders, InvestmentLoaders, WalletLoaders}
  alias Invarc.Investments.Models.Investment
  alias Invarc.Investments.Mutators.{InvestmentMutators, WalletMutators}

  def call(params) do
    with {:ok, wallet} <- verify_if_wallet_exists(params),
         {:ok} <- verify_if_is_owner(params, wallet),
         {:ok} <- verify_if_category_exists(params),
         {:ok} <- verify_if_investment_already_exists(params) do
      handle_create_investment(params, wallet)
    end
  end

  defp verify_if_wallet_exists(%{wallet_id: wallet_id}) do
    case WalletLoaders.load_one_by_id(wallet_id) do
      {:ok, wallet} -> {:ok, wallet}
      {:error, :not_found} -> Errors.wrap_not_found_error("wallet")
    end
  end

  defp verify_if_is_owner(%{account_id: account_id}, wallet) do
    is_owner = wallet.account_id == account_id

    case is_owner do
      true -> {:ok}
      false -> Errors.unauthorized_error()
    end
  end

  defp verify_if_category_exists(%{category_id: category_id}) do
    case CategoryLoaders.load_one_by_id(category_id) do
      {:ok, _} -> {:ok}
      {:error, :not_found} -> Errors.wrap_not_found_error("category")
    end
  end

  defp verify_if_investment_already_exists(%{name: name, wallet_id: wallet_id}) do
    case InvestmentLoaders.load_one_by_name_and_wallet_id(%{name: name, wallet_id: wallet_id}) do
      {:error, :not_found} -> {:ok}
      {:ok, _} -> Errors.wrap_conflict_error("name")
    end
  end

  defp handle_create_investment(params, wallet) do
    corrected_params = Map.put(params, :initial_value, params.value)

    investment_result =
      %Investment{}
      |> InvestmentChangesets.build(corrected_params)
      |> InvestmentMutators.create()

    wallet_result = handle_wallet_metrics_update(params, wallet)

    with {:ok, _} <- investment_result,
         {:ok, _} <- wallet_result do
      investment_result
    else
      {:error, _} = err -> err
    end
  end

  defp handle_wallet_metrics_update(params, wallet) do
    new_funds_applied = wallet.funds_applied + params.value

    updated_params = %{
      funds_applied: new_funds_applied
    }

    WalletMutators.update(wallet, updated_params)
  end
end
