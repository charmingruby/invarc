defmodule Invarc.Accounts.UseCases.Register do
  @moduledoc """
  Register a new account use case
  """

  alias Invarc.Accounts.Changesets.AccountChangesets
  alias Invarc.Accounts.Loaders.AccountLoader
  alias Invarc.Accounts.Models.Account
  alias Invarc.Accounts.Mutators.AccountMutators

  def call(%{email: email} = params) do
    case AccountLoader.one_by_email(email) do
      {:ok, _} -> {:error, "Email is already taken"}
      {:error, :not_found} -> handle_create_account(params)
    end
  end

  defp handle_create_account(%{name: name, email: email, password: password}) do
    new_account_params = %{
      name: name,
      email: email,
      password: password,
      role: "member",
      plan: "free"
    }

    %Account{}
    |> AccountChangesets.build(new_account_params)
    |> AccountChangesets.hash_password()
    |> AccountMutators.create()
  end
end
