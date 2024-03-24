defmodule Invarc.Accounts.Model.Account do
  @moduledoc "Account model"

  import Ecto.Changeset

  use Ecto.Schema

  @fields ~w(name email password role plan)a
  @required ~w(name email password)a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "accounts" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :role, :string
    field :plan, :string

    # relationships

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
