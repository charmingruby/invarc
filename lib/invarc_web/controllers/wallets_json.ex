defmodule InvarcWeb.WalletsJSON do
  alias InvarcWeb.Presenters

  def wallet(%{wallet: wallet}) do
    Presenters.WalletsPresenter.build_default_wallet(wallet)
  end
end
