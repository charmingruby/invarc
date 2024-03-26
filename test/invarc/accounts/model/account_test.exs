defmodule Invarc.Accounts.Model.AccountTest do
  use Invarc.DataCase, async: true

  alias Invarc.Accounts.Model.Account
  alias Invarc.Common.Security

  describe "changeset/1" do
    @invalid_account_params %{
      name: "du",
      email: "dummy_email",
      password: "1234567",
      plan: "not a plan",
      role: "not a role"
    }
    @missing_required_params %{plan: "free", role: "member"}
    @valid_params %{
      name: "dummy",
      email: "dummy@example.com",
      password: "12345678",
      plan: "free",
      role: "member"
    }
    @valid_account %Account{
      name: "dummy",
      email: "dummy@example.com",
      password: "12345678",
      plan: "premium",
      role: "manager"
    }

    test "should return an error changeset with invalid params" do
      changeset = Account.changeset(%Account{}, @invalid_account_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:email]
      assert errors_on(changeset)[:password]
      assert errors_on(changeset)[:plan]
      assert errors_on(changeset)[:role]
    end

    test "should return an error changeset with missing required params" do
      changeset = Account.changeset(%Account{}, @missing_required_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:email]
      assert errors_on(changeset)[:password]
    end

    test "should return a valid changeset on valid params" do
      changeset = Account.changeset(%Account{}, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:email]
      refute errors_on(changeset)[:password]
      refute errors_on(changeset)[:plan]
      refute errors_on(changeset)[:role]
    end

    test "should return a valid changeset with new values on new changes" do
      changeset = Account.changeset(@valid_account, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      assert @valid_params.plan == changeset.changes[:plan]
      assert @valid_params.role == changeset.changes[:role]
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:email]
      refute errors_on(changeset)[:password]
      refute errors_on(changeset)[:plan]
      refute errors_on(changeset)[:role]
    end
  end

  describe "hash_password/1" do
    @valid_account %Account{
      name: "dummy",
      email: "dummy@example.com",
      password: "12345678",
      plan: "premium",
      role: "manager"
    }

    test "should be able to validate the password hash from the valid password" do
      password_to_verify = "dummy_password"

      changeset =
        Account.changeset(@valid_account, %{password: password_to_verify})
        |> Account.hash_password()

      %Ecto.Changeset{changes: %{password_hash: password_hash_to_verify}} = changeset

      is_password_valid = Security.verify_hash(password_to_verify, password_hash_to_verify)

      assert is_password_valid == true
    end

    test "should not be able to validate the password hash from an invalid password" do
      valid_password = "dummy_password"

      changeset =
        Account.changeset(@valid_account, %{password: valid_password})
        |> Account.hash_password()

      %Ecto.Changeset{changes: %{password_hash: password_hash_to_verify}} = changeset

      is_password_valid =
        Security.verify_hash("not valid", password_hash_to_verify)

      assert is_password_valid == false
    end
  end
end
