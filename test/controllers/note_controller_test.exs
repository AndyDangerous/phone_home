defmodule PhoneHome.NoteControllerTest do
  use PhoneHome.ConnCase

  alias PhoneHome.Note
  @valid_attrs %{contact_email: "some content", contact_phone: "some content", end_time: Timex.now, trip_plan: "some content", user_phone: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, note_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing notes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, note_path(conn, :new)
    assert html_response(conn, 200) =~ "New note"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, note_path(conn, :create), note: @valid_attrs
    assert redirected_to(conn) == note_path(conn, :index)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, note_path(conn, :create), note: @invalid_attrs
    assert html_response(conn, 200) =~ "New note"
  end

  test "shows chosen resource", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = get conn, note_path(conn, :show, note)
    assert html_response(conn, 200) =~ "Show note"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, note_path(conn, :show, -1)
    end
  end
end
