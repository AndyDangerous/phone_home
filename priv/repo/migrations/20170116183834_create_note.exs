defmodule PhoneHome.Repo.Migrations.CreateNote do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :user_phone, :string
      add :end_time, :utc_datetime
      add :contact_phone, :string
      add :contact_email, :string
      add :trip_plan, :text

      timestamps()
    end

  end
end
