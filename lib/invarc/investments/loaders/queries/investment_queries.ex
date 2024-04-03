defmodule Invarc.Investments.Loaders.Queries.InvestmentQueries do
  @moduledoc """
  Module with investment read queries
  """

  alias Invarc.Investments.Models.Investment

  import Ecto.Query

  def all, do: Investment

  def one_by_id(id) do
    from c in all(),
      where: c.id == ^id
  end

  def one_by_name_and_wallet_id(%{name: name, wallet_id: wallet_id}) do
    from c in all(),
      where: c.wallet_id == ^wallet_id,
      where: c.name == ^name
  end
end
