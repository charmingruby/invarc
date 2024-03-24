defmodule Invarc.Repo.Migrations.CreateInvestmentCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:investment_categories, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)

      # relationships
      add(:account_id, references(:accounts, type: :uuid))

      timestamps()
    end
  end
end
