defmodule Invarc.Accounts.Loaders.Queries.AccountQueries do
  @moduledoc """
  Module to deal with database read queries
  """

  import Ecto.Query

  alias Invarc.Accounts.Models.Account

  def all, do: Account

  def one_by_email(email) do
    from acc in all(),
      where: acc.email == ^email
  end

  def one_by_id(id) do
    from acc in all(),
      where: acc.id == ^id
  end
end
