defmodule InvarcWeb.Presenters.WalletsPresenter do
  @moduledoc """
  Module that handles with how wallets will be represented on the responses
  """

  def build_default_wallet(wallet) do
    %{
      id: wallet.id,
      name: wallet.name,
      funds_applied: wallet.funds_applied,
      funds_received: wallet.funds_received,
      account_id: wallet.account_id,
      inserted_at: wallet.inserted_at,
      updated_at: wallet.updated_at
    }
  end

  def build_default_wallet_list(wallets) do
    Enum.map(wallets, &build_default_wallet/1)
  end
end
