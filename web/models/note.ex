defmodule PhoneHome.Note do
  use PhoneHome.Web, :model

  schema "notes" do
    field :user_phone, :string
    field :end_time, Ecto.DateTime
    field :contact_phone, :string
    field :contact_email, :string
    field :trip_plan, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_phone, :end_time, :contact_phone, :contact_email, :trip_plan])
    |> validate_required([:user_phone, :end_time, :contact_phone, :contact_email, :trip_plan])
  end
end
