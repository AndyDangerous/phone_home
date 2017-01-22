defmodule PhoneHome.NoteController do
  use PhoneHome.Web, :controller

  alias PhoneHome.Note

  def index(conn, _params) do
    notes = Repo.all(Note)
    render(conn, "index.html", notes: notes)
  end

  def new(conn, _params) do
    changeset = Note.changeset(%Note{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"note" => note_params}) do
    changeset = Note.changeset(%Note{}, note_params)

    case changeset.valid? do
      true ->
        PhoneHome.NoteServer.create(note_params)
        conn
        |> put_flash(:info, "Note created successfully.")
        |> redirect(to: note_path(conn, :index))
      false ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    note = Repo.get!(Note, id)
    render(conn, "show.html", note: note)
  end
end
