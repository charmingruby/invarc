defmodule Invarc.Investments.UseCases.TransactionsStatement do
  @moduledoc """
  Account transactions statement use case
  """

  alias Invarc.Investments.Loaders.TransactionLoaders

  def call(params) do
    TransactionLoaders.load_many_by_account_id(params)
  end
end
