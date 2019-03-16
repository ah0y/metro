defmodule Metro.Repo.Migrations.CreateCopies do
  use Ecto.Migration

  def change do
    create table(:copies) do
      add :checked_out?, :boolean, default: false, null: false
      add :library_id, references(:libraries, on_delete: :nothing)
      add :isbn_id, references(:books, column: :isbn, on_delete: :nothing)

      timestamps()
    end

    create index(:copies, [:library_id])
    create index(:copies, [:isbn_id])
  end
end
