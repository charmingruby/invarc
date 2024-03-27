defmodule Invarc.Investments.Changesets.WalletChangesetsTest do
  use Invarc.DataCase, async: true

  alias Invarc.Investments.{Changesets.WalletChangesets, Models.Wallet}

  describe "build/2" do
    @invalid_wallet_params %{
      name: "1",
      current_balance: "no current_balance",
      record_balance: "no record_balance",
      total_money_applied: "no total_money_applied"
    }
    @missing_required_params %{}
    @valid_params %{name: "dummy wallet"}
    @valid_wallet %Wallet{
      name: "new dummy name",
      current_balance: 100_000,
      record_balance: 100_000,
      total_money_applied: 100_000
    }

    test "should return an error changeset with invalid params" do
      changeset = WalletChangesets.build(%Wallet{}, @invalid_wallet_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:current_balance]
      assert errors_on(changeset)[:record_balance]
      assert errors_on(changeset)[:total_money_applied]
    end

    test "should return an error changeset with missing required params" do
      changeset = WalletChangesets.build(%Wallet{}, @missing_required_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      refute errors_on(changeset)[:current_balance]
      refute errors_on(changeset)[:record_balance]
      refute errors_on(changeset)[:total_money_applied]
    end

    test "should return a valid changeset on valid params" do
      changeset = WalletChangesets.build(%Wallet{}, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:current_balance]
      refute errors_on(changeset)[:record_balance]
      refute errors_on(changeset)[:total_money_applied]
    end

    test "should return a valid changeset with new values on new changes" do
      changeset = WalletChangesets.build(@valid_wallet, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      assert @valid_params.name == changeset.changes[:name]
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:current_balance]
      refute errors_on(changeset)[:record_balance]
      refute errors_on(changeset)[:total_money_applied]
    end
  end
end
