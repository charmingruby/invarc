defmodule Invarc.Accounts.AccountRepository do
  @moduledoc """
  Repository to interact with the database on the Accounts context
  """
  alias Invarc.Accounts.Models.Account
  alias Invarc.Repo

  def create(account) do
    Repo.insert(account)
  end

  def find_by_id(id) do
    case Repo.get(Account, id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  def find_by_email(email) do
    case Repo.get_by(Account, email: email) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end
end
