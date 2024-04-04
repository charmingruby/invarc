defmodule Invarc.Investments.UseCases.CreateWallet do
  @moduledoc """
  Create wallet use case
  """
  alias Invarc.Common.UseCases.Errors

  alias Invarc.Investments.{
    Changesets.WalletChangesets,
    Loaders.WalletLoaders,
    Models.Wallet,
    Mutators.WalletMutators
  }

  alias Invarc.Accounts.Loaders.AccountLoaders

  def call(params) do
    with {:ok} <- verify_if_account_exists(params),
         {:ok} <- verify_if_wallet_already_exists(params) do
      handle_create_wallet(params)
    end
  end

  defp verify_if_account_exists(%{account_id: account_id}) do
    case AccountLoaders.load_one_by_id(account_id) do
      {:error, :not_found} -> Errors.wrap_not_found_error("account")
      {:ok, _} -> {:ok}
    end
  end

  defp verify_if_wallet_already_exists(params) do
    case WalletLoaders.load_one_by_name_and_account_id(params) do
      {:error, :not_found} -> {:ok}
      {:ok, _} -> Errors.wrap_conflict_error("name")
    end
  end

  defp handle_create_wallet(params) do
    %Wallet{}
    |> WalletChangesets.build(params)
    |> WalletMutators.create()
  end
end
