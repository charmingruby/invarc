defmodule Invarc.Repo.Migrations.CreateInvestmentsTable do
  use Ecto.Migration

  def change do
    create table(:investments, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:description, :string)
      add(:source, :string, null: false)
      add(:initial_value, :integer, null: false)
      add(:resultant_value, :integer, null: false)

      # relationships
      add(:category_id, references(:investment_categories, type: :uuid))
      add(:wallet_id, references(:wallets, type: :uuid))

      timestamps()
    end
  end
end
