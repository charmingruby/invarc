defmodule Invarc.Common.UseCases.Errors do
  @moduledoc """
  Module to handle wrap common errors
  """

  def wrap_not_found_error(entity) do
    {:error, {:not_found, entity}}
  end

  def wrap_conflict_error(field) do
    {:error, {:conflict, field}}
  end
end
