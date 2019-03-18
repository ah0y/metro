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

      timestamps()
    end

  end
end
