defmodule Invarc.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:amount, :integer, null: false)
      add(:status, :string, null: false)
      add(:type, :string, null: false)

      # relationships
      add(:wallet_id, references(:wallets, type: :uuid))
      add(:investment_id, references(:investments, type: :uuid))
      add(:category_id, references(:investment_categories, type: :uuid))
      add(:account_id, references(:accounts, type: :uuid))

      timestamps()
    end
  end
end
