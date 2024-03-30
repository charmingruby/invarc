defmodule Invarc.Investments.Changesets.InvestmentCategoryChangesetsTest do
  use Invarc.DataCase, async: true

  alias Invarc.Investments.{Changesets.InvestmentCategoryChangesets, Models.InvestmentCategory}

  describe "build/2" do
    @invalid_category_params %{name: "x"}
    @missing_required_params %{}
    @valid_params %{name: "xp", account_id: Ecto.UUID.generate()}
    @valid_category %InvestmentCategory{name: "new dummy name"}

    test "should return an error changeset with invalid params" do
      changeset =
        InvestmentCategoryChangesets.build(%InvestmentCategory{}, @invalid_category_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:account_id]
    end

    test "should return an error changeset with missing required params" do
      changeset =
        InvestmentCategoryChangesets.build(%InvestmentCategory{}, @missing_required_params)

      assert %Ecto.Changeset{valid?: false} = changeset
      assert errors_on(changeset)[:name]
      assert errors_on(changeset)[:account_id]
    end

    test "should return a changeset on valid params" do
      changeset = InvestmentCategoryChangesets.build(%InvestmentCategory{}, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:account_id]
    end

    test "should return a valid changeset with new values on new changes" do
      changeset = InvestmentCategoryChangesets.build(@valid_category, @valid_params)

      assert %Ecto.Changeset{valid?: true} = changeset
      assert @valid_params.name == changeset.changes[:name]
      refute errors_on(changeset)[:name]
      refute errors_on(changeset)[:account_id]
    end
  end
end
