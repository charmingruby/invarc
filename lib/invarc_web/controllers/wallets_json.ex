defmodule InvarcWeb.WalletsJSON do
  alias InvarcWeb.Presenters

  def wallet(%{wallet: wallet}) do
    Presenters.WalletsPresenter.build_default_wallet(wallet)
  end

  def wallet_list(%{wallets: wallets}) do
    is_empty = length(wallets) == 0

    case is_empty do
      false -> Presenters.WalletsPresenter.build_default_wallet_list(wallets)
      true -> []
    end
  end
end
