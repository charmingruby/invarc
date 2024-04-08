defmodule Invarc.Investments.Mutators.InvestmentMutators do
  @moduledoc """
  Module to handle with database investments write operations
  """

  alias Invarc.Investments.Changesets.InvestmentChangesets
  alias Invarc.Repo

  def create(%Ecto.Changeset{} = investment) do
    Repo.insert(investment)
  end

  def update(investment, params) do
    investment
    |> InvestmentChangesets.build(params)
    |> Repo.update()
  end
end
