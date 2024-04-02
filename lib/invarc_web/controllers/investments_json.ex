defmodule InvarcWeb.InvestmentsJSON do
  alias InvarcWeb.Presenters

  def category(%{category: category}) do
    Presenters.InvestmentCategoriesPresenter.build_default_investment_category(category)
  end
end
