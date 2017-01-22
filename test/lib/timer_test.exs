defmodule PhoneHome.TimerTest do
  use ExUnit.Case
  doctest PhoneHome.Timer
  alias PhoneHome.Timer

  test "it initializes an ets table" do
    assert :ets.lookup(:note_timer, "") == []
  end

  test "it creates an entry and retrieves pids" do
    end_time = Timex.shift(Timex.now, days: 1)
    Timer.create_entry(:some_pid, end_time)

    check_in = Timex.shift(end_time, minutes: 30)
    check_in_deadline = Timex.shift(check_in, minutes: 15)
    notify_time = Timex.shift(end_time, hours: 1)

    assert Timer.retrieve_pids(end_time) == [[:some_pid]]
    assert Timer.retrieve_pids(check_in) == [[:some_pid]]
    assert Timer.retrieve_pids(check_in_deadline) == [[:some_pid]]
    assert Timer.retrieve_pids(notify_time) == [[:some_pid]]
  end
end
