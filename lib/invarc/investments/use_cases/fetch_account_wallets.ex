defmodule Invarc.Investments.UseCases.FetchAccountWallets do
  alias Invarc.Investments.Loaders.WalletLoaders

  def call(params) do
    WalletLoaders.load_many_by_account_id(params)
  end
end
