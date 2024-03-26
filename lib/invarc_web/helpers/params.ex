defmodule InvarcWeb.Helpers.Params do
  @moduledoc """
  Module with auxiliary methods to deal with request params
  """

  def cast_params(params, schema) do
    Tarams.cast(params, schema)
  end
end
