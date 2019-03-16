defmodule Metro.Repo.Migrations.CreateWaitlist do
  use Ecto.Migration

  def change do
    create table(:waitlist) do
      add :position, :integer
      add :card_id, references(:cards, on_delete: :nothing)
      add :copy_id, references(:copies, on_delete: :nothing)
      add :checkout_id, references(:checkouts, on_delete: :nothing)

      timestamps()
    end

    create index(:waitlist, [:card_id])
    create index(:waitlist, [:copy_id])
    create index(:waitlist, [:checkout_id])
  end
end
