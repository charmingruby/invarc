defmodule Invarc.Investments.Loaders.Queries.CategoryQueries do
  @moduledoc """
  Module with investment categories read queries
  """

  alias Invarc.Investments.Models.InvestmentCategory

  import Ecto.Query

  def all, do: InvestmentCategory

  def one_by_id(id) do
    from c in all(),
      where: c.id == ^id
  end

  def one_by_name_and_account_id(%{name: name, account_id: account_id}) do
    from c in all(),
      where: c.account_id == ^account_id,
      where: c.name == ^name
  end
end
