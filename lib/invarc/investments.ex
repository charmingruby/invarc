defmodule Invarc.Investments do
  @moduledoc """
  Centralizes investments use cases
  """

  alias Invarc.Investments.UseCases

  defdelegate create_wallet(params), to: UseCases.CreateWallet, as: :call
  defdelegate create_category(params), to: UseCases.CreateCategory, as: :call
  defdelegate create_investment(params), to: UseCases.CreateInvestment, as: :call
  defdelegate withdraw_investment(params), to: UseCases.WithdrawInvestment, as: :call
  defdelegate transactions_statement(params), to: UseCases.TransactionsStatement, as: :call
  defdelegate get_wallet_by_id(params), to: UseCases.GetWalletById, as: :call
  defdelegate fetch_account_wallets(params), to: UseCases.FetchAccountWallets, as: :call
end
