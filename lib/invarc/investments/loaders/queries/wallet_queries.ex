defmodule Invarc.Investments.Loaders.Queries.WalletQueries do
  @moduledoc """
  Module with wallet read queries
  """

  alias Invarc.Common.Pagination
  alias Invarc.Investments.Models.Wallet

  import Ecto.Query

  def all, do: Wallet

  def one_by_id(id) do
    from wlt in all(),
      where: wlt.id == ^id
  end

  def one_by_name_and_account_id(%{name: name, account_id: account_id}) do
    from wlt in all(),
      where: wlt.account_id == ^account_id,
      where: wlt.name == ^name
  end

  def many_by_account_id(%{page: page, account_id: account_id}) do
    limit = Pagination.items_per_page()
    offset = Pagination.items_per_page() * (page - 1)

    from t in all(),
      where: t.account_id == ^account_id,
      limit: ^limit,
      offset: ^offset
  end
end
