defmodule Invarc.Investments.Loaders.Queries.TransactionQueries do
  @moduledoc """
  Module with transaction read queries
  """

  alias Invarc.Investments.Models.Transaction

  import Ecto.Query

  def all, do: Transaction

  def many_by_investment_id(id) do
    from i in all(),
      where: i.investment_id == ^id
  end
end
