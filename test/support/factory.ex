defmodule Invarc.Factory do
  alias Invarc.Accounts.Models.Account
  use ExMachina.Ecto, repo: Invarc.Repo

  def account_factory do
    %Account{
      name: "dummy_name",
      email: "dummy@email.com",
      password_hash: "password_hash",
      plan: "free",
      role: "member"
    }
  end
end
