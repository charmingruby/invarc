defmodule Invarc.Investments.UseCases.WithdrawInvestment do
  @moduledoc """
  Withdraw investment use case
  """
  alias Ecto.Multi
  alias Invarc.Common.UseCases.Errors

  alias Invarc.Investments.Changesets.{
    InvestmentChangesets,
    TransactionChangesets,
    WalletChangesets
  }

  alias Invarc.Investments.Loaders.{
    InvestmentLoaders,
    WalletLoaders
  }

  alias Invarc.Investments.Models.Transaction
  alias Invarc.Repo

  def call(params) do
    with {:ok, wallet} <- verify_if_wallet_exists(params),
         {:ok} <- verify_if_is_owner(params, wallet),
         {:ok, investment} <- verify_if_investment_exists(params),
         {:ok} <- validate_withdrawal(investment) do
      handle_withdraw_investment_transaction(params, wallet, investment)
    end
  end

  defp verify_if_wallet_exists(%{wallet_id: wallet_id}) do
    case WalletLoaders.load_one_by_id(wallet_id) do
      {:error, :not_found} -> Errors.wrap_not_found_error("wallet")
      {:ok, wallet} -> {:ok, wallet}
    end
  end

  defp verify_if_is_owner(%{account_id: account_id}, wallet) do
    is_owner = wallet.account_id == account_id

    case is_owner do
      true -> {:ok}
      false -> Errors.unauthorized_error()
    end
  end

  defp verify_if_investment_exists(%{investment_id: investment_id}) do
    case InvestmentLoaders.load_one_by_id(investment_id) do
      {:error, :not_found} -> Errors.wrap_not_found_error("investment")
      {:ok, investment} -> {:ok, investment}
    end
  end

  defp validate_withdrawal(investment) do
    is_available_to_withdraw = investment.resultant_value == 0

    case is_available_to_withdraw do
      false -> Errors.wrap_bad_request_error("investment already withdrawed")
      true -> {:ok}
    end
  end

  defp handle_withdraw_investment_transaction(params, wallet, investment) do
    transaction =
      Multi.new()
      |> handle_update_investment_resultant_value(investment, params)
      |> handle_update_wallet_metrics(investment, wallet)
      |> handle_create_income_transaction(params, wallet)
      |> Repo.transaction()

    case transaction do
      {:ok, result} -> {:ok, result.investment}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  defp handle_create_income_transaction(multi, params, wallet) do
    Multi.insert(multi, :transaction, fn %{investment: investment} ->
      transaction_name =
        TransactionChangesets.build_transaction_name(%{wallet_name: wallet.name, type: "income"})

      transaction_params = %{
        name: transaction_name,
        amount: params.resultant_value,
        status: "success",
        type: "income",
        wallet_id: wallet.id,
        investment_id: investment.id,
        category_id: investment.category_id
      }

      %Transaction{}
      |> TransactionChangesets.build(transaction_params)
    end)
  end

  defp handle_update_investment_resultant_value(multi, investment, %{
         resultant_value: resultant_value
       }) do
    updated_params =
      %{resultant_value: resultant_value}

    changeset = InvestmentChangesets.build(investment, updated_params)

    Multi.update(multi, :investment, changeset)
  end

  defp handle_update_wallet_metrics(multi, investment, wallet) do
    updated_wallet_params = %{
      funds_received: wallet.funds_received + investment.resultant_value
    }

    changeset = WalletChangesets.build(wallet, updated_wallet_params)

    Multi.update(multi, :wallet_metrics, changeset)
  end
end
