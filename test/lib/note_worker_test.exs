defmodule PhoneHome.NoteWorkerTest do
  use ExUnit.Case
  doctest PhoneHome.NoteWorker
  alias PhoneHome.NoteWorker

  @phone "some user phone number"
  @valid_attrs %{
    contact_email: "some content",
    contact_phone: "some content",
    end_time: Timex.now,
    trip_plan: "some content",
    user_phone: @phone
  }

  test "it initializes with note details" do
    NoteWorker.start_link(@valid_attrs)
    assert @valid_attrs = NoteWorker.status(@phone)
  end

  test "it starts state machine" do
    NoteWorker.start_link(@valid_attrs)
    %{note_state: note_state} = NoteWorker.status(@phone)
    assert note_state == :in_progress
  end

  test "it can set state to safe" do
    NoteWorker.start_link(@valid_attrs)
    NoteWorker.safe(@phone)
    %{note_state: note_state} = NoteWorker.status(@phone)
    assert note_state == :safe
  end
  
  test "update cycles state" do
    NoteWorker.start_link(@valid_attrs)
    :await_check_in = NoteWorker.update(@phone)
    {:send_reminder, _info} = NoteWorker.update(@phone)
    {:notify_contact, _info} = NoteWorker.update(@phone)
  end
end
