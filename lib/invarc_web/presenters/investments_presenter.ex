defmodule InvarcWeb.Presenters.InvestmentsPresenter do
  @moduledoc """
  Module that handles with how investments will be represented on the responses
  """

  def build_default_investment(investment) do
    initial_value_parsed = investment.initial_value / 100
    resultant_value_parsed = investment.resultant_value / 100

    %{
      id: investment.id,
      name: investment.name,
      description: investment.description,
      source: investment.source,
      initial_value: initial_value_parsed,
      resultant_value: resultant_value_parsed,
      category_id: investment.category_id,
      wallet_id: investment.wallet_id,
      inserted_at: investment.inserted_at,
      updated_at: investment.updated_at
    }
  end
end
