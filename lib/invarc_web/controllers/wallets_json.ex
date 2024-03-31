defmodule InvarcWeb.WalletsJSON do
  alias InvarcWeb.Presenters

  def wallet(%{wallet: wallet}) do
    Presenters.WalletsPresenter.build_default_wallet(wallet)
  end

  def category(%{category: category}) do
    Presenters.InvestmentCategoriesPresenter.build_default_investment_category(category)
  end
end
