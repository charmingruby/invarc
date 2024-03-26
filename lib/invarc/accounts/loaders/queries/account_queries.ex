defmodule Invarc.Accounts.Loaders.Queries.AccountQueries do
  import Ecto.Query

  alias Invarc.Accounts.Models.Account

  def all, do: Account

  def one_by_email(email) do
    from acc in all(),
      where: acc.email == ^email
  end
end
