defmodule Invarc.Investments.UseCases.CreateWallet do
  @moduledoc """
  Create wallet use case
  """
  alias Invarc.Investments.{
    Changesets.WalletChangesets,
    Loaders.WalletLoaders,
    Models.Wallet,
    Mutators.WalletMutators
  }

  alias Invarc.Accounts.Loaders.AccountLoaders

  def call(%{account_id: account_id} = params) do
    case AccountLoaders.one_by_id(account_id) do
      {:error, :not_found} -> {:error, {:not_found, "account"}}
      {:ok, _} -> verify_if_wallet_already_exists(params)
    end
  end

  defp verify_if_wallet_already_exists(params) do
    case WalletLoaders.one_by_name_in_wallet(params) do
      {:error, :not_found} -> handle_create_wallet(params)
      {:ok, _} -> {:error, {:conflict, "name"}}
    end
  end

  defp handle_create_wallet(params) do
    %Wallet{}
    |> WalletChangesets.build(params)
    |> WalletMutators.create()
  end
end
