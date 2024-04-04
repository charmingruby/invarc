defmodule Invarc.Repo.Migrations.CreateWalletsTable do
  use Ecto.Migration

  def change do
    create table(:wallets, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:funds_received, :integer, null: false)
      add(:funds_applied, :integer, null: false)

      # relationships
      add(:account_id, references(:accounts, type: :uuid))

      timestamps()
    end
  end
end
