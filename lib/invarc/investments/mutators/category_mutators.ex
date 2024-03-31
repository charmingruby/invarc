defmodule Invarc.Investments.Mutators.CategoryMutators do
  @moduledoc """
  Module to handle with database categories write operations
  """

  alias Invarc.Repo

  def create(%Ecto.Changeset{} = category) do
    Repo.insert(category)
  end
end
