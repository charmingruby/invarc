defmodule Invarc.Investments.Changesets.InvestmentChangesets do
  @moduledoc """
  Module to deal with investments changeset validations
  """

  alias Invarc.Investments.Models.Investment

  import Ecto.Changeset

  @fields ~w(name description source initial_value resultant_value category_id wallet_id)a
  @required ~w(name description source initial_value category_id wallet_id)a

  def build(%Investment{} = investment, params) do
    investment
    |> cast(params, @fields)
    |> validate_required(@required)
    |> validate_rules()
  end

  defp validate_rules(changeset) do
    changeset
    |> validate_length(:name, min: 2, max: 32)
    |> validate_length(:description, min: 8, max: 64)
    |> validate_length(:source, min: 2, max: 32)
  end
end
