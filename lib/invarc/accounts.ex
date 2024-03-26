defmodule Invarc.Accounts do
  alias Invarc.Accounts.Models.Account
  alias Invarc.Accounts.AccountRepository

  def register(%{email: email} = params) do
    case AccountRepository.find_by_email(email) do
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
    |> Account.changeset(new_account_params)
    |> Account.hash_password()
    |> AccountRepository.create()
  end
end
