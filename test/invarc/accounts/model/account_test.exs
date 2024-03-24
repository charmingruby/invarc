defmodule Invarc.Accounts.Model.AccountTest do
  use Invarc.DataCase, async: true

  alias Invarc.Accounts.Model.Account

  describe "changeset/1" do
    @invalid_account_params %{
      name: 123,
      email: nil,
      password: 123,
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
end
