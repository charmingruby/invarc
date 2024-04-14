defmodule Invarc.Factory do
  @moduledoc """
  Models factories
  """

  use ExMachina.Ecto, repo: Invarc.Repo

  alias Invarc.Accounts.Models.Account
  alias Invarc.Investments.Models.{Investment, InvestmentCategory, Transaction, Wallet}

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

  def investment_category_factory do
    %InvestmentCategory{
      name: "dummy_category_name",
      account_id: nil
    }
  end

  def investment_factory do
    %Investment{
      name: "dummy name",
      description: "dummy investment",
      source: "dummy investment source",
      initial_value: 100_000,
      resultant_value: 0,
      wallet_id: nil,
      category_id: nil
    }
  end

  def transaction_factory do
    %Transaction{
      name: "",
      investment_id: nil,
      category_id: nil,
      wallet_id: nil,
      amount: 100_000,
      type: "",
      status: ""
    }
  end
end
