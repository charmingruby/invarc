defmodule Invarc.Repo.Migrations.CreateWalletsTable do
  use Ecto.Migration

  def change do
    create table(:wallets, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:current_balance, :integer, null: false)
      add(:record_balance, :integer)
      add(:total_money_applied, :integer, null: false)

      # relationships
      add(:account_id, references(:accounts, type: :uuid))

      timestamps()
    end
  end
end
