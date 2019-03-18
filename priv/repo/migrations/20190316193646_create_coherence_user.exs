defmodule Metro.Repo.Migrations.CreateCoherenceUser do
  use Ecto.Migration
  def change do
    create table(:users) do

      add :name, :string
      add :email, :string
      # authenticatable
      add :password_hash, :string
      # recoverable
      add :reset_password_token, :string
      add :reset_password_sent_at, :utc_datetime
      # lockable
      add :failed_attempts, :integer, default: 0
      add :locked_at, :utc_datetime
      # trackable
      add :sign_in_count, :integer, default: 0
      add :current_sign_in_at, :utc_datetime
      add :last_sign_in_at, :utc_datetime
      add :current_sign_in_ip, :string
      add :last_sign_in_ip, :string
      # unlockable_with_token
      add :unlock_token, :string

      add :fines, :float
      add :is_librarian?, :boolean, default: false
      add :num_books_out, :integer
      add :card_id, references(:cards, on_delete: :nothing)
      add :library_id, references(:libraries, on_delete: :nothing)
      
      timestamps()
    end
    create unique_index(:users, [:email])
    create index(:users, [:card_id])
    create index(:users, [:library_id])
  end
end
