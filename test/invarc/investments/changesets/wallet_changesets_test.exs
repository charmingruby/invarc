defmodule Invarc.Investments.Changesets.WalletChangesetsTest do
  use Invarc.DataCase, async: true

  alias Invarc.Investments.{Changesets.WalletChangesets, Models.Wallet}

  describe "build/2" do
    @invalid_wallet_params %{
      name: "1",
      funds_received: "no funds_received",
      funds_applied: "no funds_applied",
      account_id: 12
    }
    @missing_required_params %{}
    @valid_params %{name: "dummy wallet", account_id: Ecto.UUID.generate()}
    @valid_wallet %Wallet{
      name: "new dummy name",
      funds_received: 100_000,
      funds_applied: 100_000,
      account_id: Ecto.UUID.generate()
    }

    test "should return an error changeset with invalid params" do
      changeset = WalletChangesets.build(%Wallet{}, @invalid_wallet_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:funds_received]
      assert errors_on(changeset)[:funds_applied]
      assert errors_on(changeset)[:account_id]
    end

    test "should return an error changeset with missing required params" do
      changeset = WalletChangesets.build(%Wallet{}, @missing_required_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      refute errors_on(changeset)[:funds_received]
      refute errors_on(changeset)[:funds_applied]
      assert errors_on(changeset)[:account_id]
    end

    test "should return a valid changeset on valid params" do
      changeset = WalletChangesets.build(%Wallet{}, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:funds_received]
      refute errors_on(changeset)[:funds_applied]
      refute errors_on(changeset)[:account_id]
    end

    test "should return a valid changeset with new values on new changes" do
      changeset = WalletChangesets.build(@valid_wallet, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      assert @valid_params.name == changeset.changes[:name]
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:funds_received]
      refute errors_on(changeset)[:funds_applied]
      refute errors_on(changeset)[:account_id]
    end
  end
end
