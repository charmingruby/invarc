defmodule Invarc.Investments do
  @moduledoc """
  Centralizes investments use cases
  """

  alias Invarc.Investments.UseCases

  defdelegate create_wallet(params), to: UseCases.CreateWallet, as: :call
end
