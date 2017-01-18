# init ets table
# check time.now and send relevant messages to server
# loop every minute?
# on new_entry:
  # calculate various times
  # add times to new entry in ets table

defmodule PhoneHome.Timer do
  require IEx

  @table :note_timer

  def initialize do
    :ets.new(@table, [:bag, :named_table])
    :ok
  end

  def loop do
    %{year: year, month: month, day: day, hour: hour, minute: minute} = DateTime.utc_now
    pids = :ets.match(@table, {"$1", %{year: year, month: month, day: day, hour: hour, minute: minute}})
    # |> do_something with pids
  end

  def create_entry(pid, end_time) do
    end_time
    |> calculate_times
    |> insert_times(pid)
  end

  defp calculate_times(end_time) do
    [end_time]
  end

  defp insert_times(times, pid) do
    times
    |> Enum.each( fn(time) ->
      :ets.insert(@table, {pid, time})
    end)
  end
end
