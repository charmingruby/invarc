defmodule InvarcWeb.Presenters.WalletsPresenter do
  @moduledoc """
  Module that handles with how wallets will be represented on the responses
  """

  def build_default_wallet(wallet) do
    %{
      id: wallet.id,
      name: wallet.name,
      current_balance: wallet.current_balance,
      record_balance: wallet.record_balance,
      total_money_applied: wallet.total_money_applied,
      account_id: wallet.account_id,
      inserted_at: wallet.inserted_at,
      updated_at: wallet.updated_at
    }
  end
end
