defmodule Invarc.Investments.Mutators.WalletMutators do
  @moduledoc """
  Module to handle with database wallets write operations
  """

  alias Invarc.Investments.Changesets.WalletChangesets
  alias Invarc.Repo

  def create(%Ecto.Changeset{} = wallet) do
    Repo.insert(wallet)
  end

  def update(wallet, params) do
    wallet
    |> WalletChangesets.build(params)
    |> Repo.update()
  end
end
