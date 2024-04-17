defmodule Invarc.Investments.UseCases.GetWalletById do
  alias Invarc.Common.UseCases.Errors
  alias Invarc.Investments.Loaders.WalletLoaders

  def call(%{wallet_id: wallet_id, account: account}) do
    with {:ok, wallet} <- WalletLoaders.load_one_by_id(wallet_id) do
      is_wallet_owner = wallet.account_id == account.id

      case is_wallet_owner do
        true -> {:ok, wallet}
        false -> Errors.unauthorized_error()
      end
    end
  end
end
