defmodule Invarc.Investments.Changesets.InvestmentCategoryChangesets do
  @moduledoc """
  Module to deal with investment categories changeset validations
  """

  alias Invarc.Investments.Models.InvestmentCategory

  import Ecto.Changeset

  @fields ~w(name account_id)a
  @required ~w(name account_id)a

  def build(struct \\ %InvestmentCategory{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
    |> validation_rules()
  end

  defp validation_rules(changeset) do
    changeset
    |> validate_length(:name, min: 2, max: 24)
  end
end
