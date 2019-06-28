defmodule Metro.Repo.Migrations.AddBookGenresTable do
  use Ecto.Migration

  def change do
    create table(:book_genres, primary_key: false) do
      add :isbn_id, references(:books, column: :isbn, on_delete: :nothing)
      add :genre_id, references(:genres, on_delete: :nothing)
      timestamps()
    end

    create(index(:book_genres, [:isbn_id]))
    create(index(:book_genres, [:genre_id]))

    create(unique_index(:book_genres, [:isbn_id, :genre_id], name: :isbn_id_genre_id_unique_index))
  end
end
