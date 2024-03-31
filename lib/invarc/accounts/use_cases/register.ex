defmodule Invarc.Accounts.UseCases.Register do
  @moduledoc """
  Register a new account use case
  """

  alias Invarc.Accounts.{
    Changesets.AccountChangesets,
    Loaders.AccountLoaders,
    Models.Account,
    Mutators.AccountMutators
  }

  alias Invarc.Common.UseCases.Errors

  def call(%{email: email} = params) do
    case AccountLoaders.load_one_by_email(email) do
      {:ok, _} -> Errors.wrap_conflict_error("email")
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
