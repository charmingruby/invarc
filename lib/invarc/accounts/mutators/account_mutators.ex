defmodule Invarc.Accounts.Mutators.AccountMutators do
  @moduledoc """
  Module to deal with database write operations
  """

  alias Invarc.Repo

  def create(account) do
    Repo.insert(account)
  end
end
