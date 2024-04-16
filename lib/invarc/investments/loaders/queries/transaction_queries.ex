defmodule Invarc.Investments.Loaders.Queries.TransactionQueries do
  @moduledoc """
  Module with transaction read queries
  """

  alias Invarc.Common.Pagination
  alias Invarc.Investments.Models.Transaction

  import Ecto.Query

  def all, do: Transaction

  def many_by_account_id(%{account_id: account_id, page: page}) do
    limit = Pagination.items_per_page()
    offset = Pagination.items_per_page() * (page - 1)

    from t in all(),
      where: t.account_id == ^account_id,
      limit: ^limit,
      offset: ^offset
  end

  def many_by_investment_id(id) do
    from t in all(),
      where: t.investment_id == ^id
  end
end
