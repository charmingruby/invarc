defmodule Invarc.Investments.UseCases.CreateInvestment do
  @moduledoc """
  Create investment use case
  """

  alias Ecto.Multi
  alias Invarc.Common.UseCases.Errors

  alias Invarc.Investments.Changesets.{
    InvestmentChangesets,
    TransactionChangesets,
    WalletChangesets
  }

  alias Invarc.Investments.Loaders.{CategoryLoaders, InvestmentLoaders, WalletLoaders}
  alias Invarc.Investments.Models.{Investment, Transaction}
  alias Invarc.Repo

  def call(params) do
    with {:ok, wallet} <- verify_if_wallet_exists(params),
         {:ok} <- verify_if_is_owner(params, wallet),
         {:ok} <- verify_if_category_exists(params),
         {:ok} <- verify_if_investment_already_exists(params) do
      # handle_create_investment(params, wallet)
      handle_create_investment_transaction(params, wallet)
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

  defp handle_create_investment_transaction(params, wallet) do
    transaction =
      Multi.new()
      |> handle_create_outcome_transaction(params, wallet)
      |> handle_wallet_metrics_update(params, wallet)
      |> handle_create_investment(params)
      |> Repo.transaction()

    case transaction do
      {:ok, result} -> {:ok, result.investment}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  defp handle_create_outcome_transaction(multi, params, wallet) do
    transaction_name =
      TransactionChangesets.build_transaction_name(%{wallet_name: wallet.name, type: "outcome"})

    transaction_params = %{
      name: transaction_name,
      amount: params.value,
      status: "success",
      type: "outcome",
      wallet_id: wallet.id
    }

    transaction =
      %Transaction{}
      |> TransactionChangesets.build(transaction_params)

    Multi.insert(multi, :transaction, transaction)
  end

  defp handle_create_investment(multi, params) do
    corrected_params = Map.put(params, :initial_value, params.value)

    investment =
      %Investment{}
      |> InvestmentChangesets.build(corrected_params)

    Multi.insert(multi, :investment, investment)
  end

  defp handle_wallet_metrics_update(multi, params, wallet) do
    new_funds_applied = wallet.funds_applied + params.value

    updated_params = %{
      funds_applied: new_funds_applied
    }

    changeset = WalletChangesets.build(wallet, updated_params)

    Multi.update(multi, :wallet_metrics, changeset)
  end
end
