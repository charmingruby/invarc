defmodule InvarcWeb.Helpers.Params do
  @moduledoc """
  Module with auxiliary methods to deal with request params
  """

  def cast_params(params, schema) do
    Tarams.cast(params, schema)
    |> handle_result()
  end

  defp handle_result({:error, params}), do: {:error, {:params_cast, params}}
  defp handle_result(result), do: result
end
