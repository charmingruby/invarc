defmodule InvarcWeb.Presenters.InvestmentsPresenter do
  @moduledoc """
  Module that handles with how investments will be represented on the responses
  """

  def build_default_investment(investment) do
    initial_value_parsed = investment.initial_value / 100

    %{
      id: investment.id,
      name: investment.name,
      description: investment.description,
      source: investment.source,
      initial_value: initial_value_parsed,
      resultant_value: investment.resultant_value,
      category_id: investment.category_id,
      wallet_id: investment.wallet_id,
      inserted_at: investment.inserted_at,
      updated_at: investment.updated_at
    }
  end
end
