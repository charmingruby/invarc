defmodule Invarc.Accounts.Mutators.AccountMutators do
  alias Invarc.Repo

  def create(account) do
    Repo.insert(account)
  end
end
