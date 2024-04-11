defmodule Invarc.Investments.Mutators.TransactionMutators do
  @moduledoc """
  Module to handle with database transactions write operations
  """

  alias Invarc.Repo

  def create(%Ecto.Changeset{} = transaction) do
    Repo.insert(transaction)
  end
end
