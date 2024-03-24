defmodule Invarc.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:email, :string, null: false)
      add(:password, :string, null: false)
      add(:role, :string, null: false)
      add(:plan, :string, null: false)

      timestamps()
    end

    create unique_index(:accounts, [:email])
  end
end
