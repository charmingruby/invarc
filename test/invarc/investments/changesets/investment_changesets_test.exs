defmodule Invarc.Investments.Changesets.InvestmentChangesetsTest do
  use Invarc.DataCase, async: true

  alias Invarc.Investments.Changesets.InvestmentChangesets
  alias Invarc.Investments.Models.Investment

  describe "build/2" do
    @invalid_investment_params %{
      name: "x",
      description: "y",
      source: "z",
      category_id: nil,
      wallet_id: nil
    }
    @missing_required_params %{}
    @valid_params %{
      name: "easy going investment",
      description: "an investment without headaches, only deposit money and receives",
      source: "dummy bank",
      category_id: Ecto.UUID.generate(),
      wallet_id: Ecto.UUID.generate()
    }
    @valid_investment %Investment{
      name: "hard investment",
      description: "unstable investment with chance to multiply of 50%",
      source: "not dummy bank",
      category_id: Ecto.UUID.generate(),
      wallet_id: Ecto.UUID.generate()
    }

    test "should return an error changeset with invalid params" do
      changeset =
        InvestmentChangesets.build(%Investment{}, @invalid_investment_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:description]
      assert errors_on(changeset)[:source]
      assert errors_on(changeset)[:category_id]
      assert errors_on(changeset)[:wallet_id]
    end

    test "should return an error changeset with missing required params" do
      changeset =
        InvestmentChangesets.build(%Investment{}, @missing_required_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:description]
      assert errors_on(changeset)[:source]
      assert errors_on(changeset)[:category_id]
      assert errors_on(changeset)[:wallet_id]
    end

    test "should return a changeset on valid params" do
      changeset = InvestmentChangesets.build(%Investment{}, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:description]
      refute errors_on(changeset)[:source]
      refute errors_on(changeset)[:category_id]
      refute errors_on(changeset)[:wallet_id]
    end

    test "should return a valid changeset with new values on new changes" do
      changeset = InvestmentChangesets.build(@valid_investment, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset

      assert @valid_params.name == changeset.changes[:name]
      assert @valid_params.description == changeset.changes[:description]
      assert @valid_params.source == changeset.changes[:source]
      assert @valid_params.category_id == changeset.changes[:category_id]
      assert @valid_params.wallet_id == changeset.changes[:wallet_id]

      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:description]
      refute errors_on(changeset)[:source]
      refute errors_on(changeset)[:category_id]
      refute errors_on(changeset)[:wallet_id]
    end
  end
end
