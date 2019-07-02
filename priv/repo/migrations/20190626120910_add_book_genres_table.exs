defmodule Metro.Repo.Migrations.AddBookGenresTable do
  use Ecto.Migration

  def change do
    create table(:book_genres, primary_key: false) do
      add :book_isbn, references(:books, column: :isbn, on_delete: :nothing)
      add :genre_id, references(:genres, on_delete: :nothing)
      timestamps()
    end

    create(index(:book_genres, [:book_isbn]))
    create(index(:book_genres, [:genre_id]))

    create(unique_index(:book_genres, [:book_isbn, :genre_id], name: :book_isbn_genre_id_unique_index))
  end
end
