defmodule Invarc.Factory do
  use ExMachina.Ecto, repo: Invarc.Repo

  alias Invarc.Investments.Models.Wallet
  alias Invarc.Accounts.Models.Account

  def account_factory do
    %Account{
      name: "dummy_name",
      email: "dummy@email.com",
      password_hash: Argon2.hash_pwd_salt("password123"),
      plan: "free",
      role: "member"
    }
  end

  def wallet_factory do
    %Wallet{
      name: "dummy_wallet_name",
      funds_applied: 0,
      funds_received: 0,
      account_id: nil
    }
  end
end
