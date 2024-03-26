defmodule Invarc.Accounts do
  alias Invarc.Accounts

  defdelegate register(params), to: Accounts.UseCases.Register, as: :call
end
