defmodule Invarc.Investments do
  @moduledoc """
  Centralizes investments use cases
  """

  alias Invarc.Investments.UseCases

  defdelegate create_wallet(params), to: UseCases.CreateWallet, as: :call
  defdelegate create_category(params), to: UseCases.CreateCategory, as: :call
  defdelegate create_investment(params), to: UseCases.CreateInvestment, as: :call
  defdelegate withdraw_investment(params), to: UseCases.WithdrawInvestment, as: :call
end
