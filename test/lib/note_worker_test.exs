defmodule PhoneHome.NoteWorkerTest do
  use ExUnit.Case
  doctest PhoneHome.NoteWorker
  alias PhoneHome.NoteWorker

  @valid_attrs %{contact_email: "some content", contact_phone: "some content", end_time: Timex.now, trip_plan: "some content", user_phone: "some content"}

  test "it initializes with note details" do
    {:ok, pid} = NoteWorker.start_link(@valid_attrs)
    assert @valid_attrs = NoteWorker.status(pid)
  end

  test "it starts state machine" do
    {:ok, pid} = NoteWorker.start_link(@valid_attrs)
    %{note_state: note_state} = NoteWorker.status(pid)
    assert note_state == :in_progress
  end

  test "it can set state to safe" do
    {:ok, pid} = NoteWorker.start_link(@valid_attrs)
    NoteWorker.safe(pid)
    %{note_state: note_state} = NoteWorker.status(pid)
    assert note_state == :safe
  end
  
  test "update cycles state" do
    {:ok, pid} = NoteWorker.start_link(@valid_attrs)
    :await_check_in = NoteWorker.update(pid)
    {:send_reminder, _info} = NoteWorker.update(pid)
    {:notify_contact, _info} = NoteWorker.update(pid)
  end
end
