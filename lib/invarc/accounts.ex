defmodule Invarc.Accounts do
  @moduledoc """
  Centralizes accounts use cases
  """

  alias Invarc.Accounts

  defdelegate register(params), to: Accounts.UseCases.Register, as: :call
end
