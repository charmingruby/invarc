defmodule InvarcWeb.Presenters.InvestmentCategoriesPresenter do
  @moduledoc """
  Module that handles with how investment categories will be represented on the responses
  """

  def build_default_investment_category(category) do
    %{
      id: category.id,
      name: category.name,
      account_id: category.account_id,
      inserted_at: category.inserted_at,
      updated_at: category.updated_at
    }
  end
end
