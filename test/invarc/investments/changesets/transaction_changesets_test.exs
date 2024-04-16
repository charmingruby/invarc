defmodule Invarc.Investments.Changesets.TransactionChangesetsTest do
  use Invarc.DataCase, async: true

  alias Invarc.Investments.Changesets.TransactionChangesets
  alias Invarc.Investments.Models.Transaction

  describe "build/2" do
    @invalid_transaction_params %{
      name: 2,
      amount: -10_000,
      status: "pending",
      type: "investment",
      wallet_id: 1,
      category_id: 1,
      investment_id: 1
    }
    @missing_required_params %{}
    @valid_params %{
      name:
        TransactionChangesets.build_transaction_name(%{
          wallet_name: "dummy_wallet",
          type: "income"
        }),
      amount: 10_000,
      status: "success",
      type: "income",
      wallet_id: Ecto.UUID.generate(),
      category_id: Ecto.UUID.generate(),
      investment_id: Ecto.UUID.generate(),
      account_id: Ecto.UUID.generate()
    }
    @valid_transaction %Transaction{
      name:
        TransactionChangesets.build_transaction_name(%{
          wallet_name: "dummy_wallet",
          type: "outcome"
        }),
      amount: 20_000,
      status: "rollback",
      type: "outcome",
      wallet_id: Ecto.UUID.generate()
    }

    test "should return an error changeset with invalid params" do
      changeset =
        TransactionChangesets.build(%Transaction{}, @invalid_transaction_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:amount]
      assert errors_on(changeset)[:status]
      assert errors_on(changeset)[:type]
      assert errors_on(changeset)[:wallet_id]
      assert errors_on(changeset)[:category_id]
      assert errors_on(changeset)[:investment_id]
      assert errors_on(changeset)[:account_id]
    end

    test "should return an error changeset with missing required params" do
      changeset =
        TransactionChangesets.build(%Transaction{}, @missing_required_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:amount]
      assert errors_on(changeset)[:status]
      assert errors_on(changeset)[:type]
      assert errors_on(changeset)[:wallet_id]
      assert errors_on(changeset)[:category_id]
      assert errors_on(changeset)[:investment_id]
      assert errors_on(changeset)[:account_id]
    end

    test "should return a changeset on valid params" do
      changeset = TransactionChangesets.build(%Transaction{}, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:amount]
      refute errors_on(changeset)[:status]
      refute errors_on(changeset)[:type]
      refute errors_on(changeset)[:wallet_id]
      refute errors_on(changeset)[:category_id]
      refute errors_on(changeset)[:investment_id]
      refute errors_on(changeset)[:account_id]
    end

    test "should return a valid changeset with new values on new changes" do
      changeset = TransactionChangesets.build(@valid_transaction, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset

      assert @valid_params.name == changeset.changes[:name]
      assert @valid_params.amount == changeset.changes[:amount]
      assert @valid_params.status == changeset.changes[:status]
      assert @valid_params.type == changeset.changes[:type]
      assert @valid_params.wallet_id == changeset.changes[:wallet_id]

      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:amount]
      refute errors_on(changeset)[:status]
      refute errors_on(changeset)[:type]
      refute errors_on(changeset)[:wallet_id]
      refute errors_on(changeset)[:category_id]
      refute errors_on(changeset)[:investment_id]
    end
  end
end
