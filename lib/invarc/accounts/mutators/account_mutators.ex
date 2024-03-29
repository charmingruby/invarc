defmodule Invarc.Accounts.Mutators.AccountMutators do
  @moduledoc """
  Module to handle with database accounts write operations
  """

  alias Invarc.Repo

  def create(%Ecto.Changeset{} = account) do
    Repo.insert(account)
  end
end
