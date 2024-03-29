defmodule InvarcWeb.WalletsJSON do
  alias InvarcWeb.Presenters.WalletsPresenter

  def wallet(%{wallet: wallet}) do
    WalletsPresenter.build_default_wallet(wallet)
  end
end
