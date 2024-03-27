defmodule Invarc.Accounts do
  @moduledoc """
  Centralizes accounts use cases
  """

  alias Invarc.Accounts.UseCases

  defdelegate register(params), to: UseCases.Register, as: :call
  defdelegate authenticate(params), to: UseCases.Authenticate, as: :call
end
