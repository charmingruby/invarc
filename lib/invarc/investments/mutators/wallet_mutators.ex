defmodule Invarc.Investments.Mutators.WalletMutators do
  @moduledoc """
  Module to handle with database wallets write operations
  """

  alias Invarc.Repo

  def create(%Ecto.Changeset{} = wallet) do
    Repo.insert(wallet)
  end
end
