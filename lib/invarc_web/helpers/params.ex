defmodule InvarcWeb.Helpers.Params do
  def cast_params(params, schema) do
    Tarams.cast(params, schema)
  end
end
