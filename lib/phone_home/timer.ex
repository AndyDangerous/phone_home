defmodule PhoneHome.Timer do
  use Timex

  @table :note_timer

  def initialize do
    :ets.new(@table, [:bag, :named_table, :public])
    :ok
  end

  def create_entry(pid, end_time) do
    end_time
    |> calculate_times
    |> insert_times(pid)
  end

  def retrieve_phone_numbers do
    retrieve_phone_numbers(Timex.now)
  end

  def retrieve_phone_numbers(datetime) do
    erl_time = datetime
    |> to_erl_time

    {{year, month, day}, {hours, minutes, _seconds}} = erl_time

    :ets.match(@table, {:"$1", {{year, month, day}, {hours, minutes, :"_"}}})
  end

  defp calculate_times(end_time) do
    end_time
    |> add_check_in
    |> add_check_in_deadline
    |> add_notify_time
    |> Tuple.to_list
  end

  defp add_check_in(end_time) do
    check_in = Timex.shift(end_time, minutes: 30)
    {check_in, end_time}
  end

  defp add_check_in_deadline({check_in, end_time}) do
    check_in_deadline = Timex.shift(check_in, minutes: 15)
    {check_in_deadline, check_in, end_time}
  end

  defp add_notify_time({check_in_deadline, check_in, end_time}) do
    notify_time = Timex.shift(end_time, hours: 1)
    {notify_time, check_in_deadline, check_in, end_time}
  end

  defp insert_times(times, pid) do
    times
    |> Enum.each( fn(time) ->
      insert_time(time, pid)
    end)
  end

  defp insert_time(time, pid) do
    erl_time = time
    |> to_erl_time

    :ets.insert(@table, {pid, erl_time})
  end

  defp to_erl_time(time) do
    timezone = Timezone.get("America/Denver", Timex.now)
    Timezone.convert(time, timezone)
    |> Timex.to_erl
  end
end
