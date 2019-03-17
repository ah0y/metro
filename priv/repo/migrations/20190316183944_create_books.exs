defmodule Metro.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :isbn, :bigint, primary_key: true
      add :title, :string
      add :year, :integer
      add :summary, :text
      add :pages, :integer
      add :image, :string
      add :author_id, references(:authors, on_delete: :nothing)

      timestamps()
    end

    create index(:books, [:author_id])
  end
end
