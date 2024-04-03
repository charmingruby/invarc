defmodule Invarc.Investments.Mutators.InvestmentMutators do
  @moduledoc """
  Module to handle with database investments write operations
  """

  alias Invarc.Repo

  def create(%Ecto.Changeset{} = investment) do
    Repo.insert(investment)
  end
end
