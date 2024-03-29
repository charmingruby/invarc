defmodule Invarc.Investments.Loaders.Queries.WalletQueries do
  @moduledoc """
  Module with wallet read queries
  """

  alias Invarc.Investments.Models.Wallet

  import Ecto.Query

  def all, do: Wallet

  def one_by_name_of_an_account(%{name: name, account_id: account_id}) do
    from wlt in all(),
      where: wlt.account_id == ^account_id,
      where: wlt.name == ^name
  end
end
