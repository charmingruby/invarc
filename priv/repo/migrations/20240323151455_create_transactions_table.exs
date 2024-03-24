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
      add(:wallet_receiver_id, references(:wallets, type: :uuid))
      add(:wallet_sender_id, references(:wallets, type: :uuid))
      add(:investment_receiver_id, references(:investments, type: :uuid))
      add(:investment_sender_id, references(:investments, type: :uuid))
      add(:category_id, references(:investment_categories, type: :uuid))

      timestamps()
    end
  end
end
