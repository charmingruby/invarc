defmodule Invarc.Investments.UseCases.WithdrawInvestment do
  alias Invarc.Common.UseCases.Errors

  alias Invarc.Investments.{
    Mutators.WalletMutators,
    Mutators.InvestmentMutators,
    Loaders.InvestmentLoaders,
    Loaders.WalletLoaders
  }

  def call(params) do
    with {:ok, wallet} <- verify_if_wallet_exists(params),
         {:ok} <- verify_if_is_owner(params, wallet),
         {:ok, investment} <- verify_if_investment_exists(params),
         {:ok} <- validate_withdrawal(investment),
         {:ok, updated_investment} <- handle_update_investment_resultant_value(investment, params) do
      handle_update_wallet_metrics(updated_investment, wallet)
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

  defp handle_update_investment_resultant_value(investment, %{resultant_value: resultant_value}) do
    updated_params =
      %{resultant_value: resultant_value}

    InvestmentMutators.update(investment, updated_params)
  end

  defp handle_update_wallet_metrics(updated_investment, wallet) do
    updated_wallet_params = %{
      funds_received: wallet.funds_received + updated_investment.resultant_value
    }

    case WalletMutators.update(wallet, updated_wallet_params) do
      {:error, _reason} = err -> err
      {:ok, _wallet} -> {:ok, updated_investment}
    end
  end
end
