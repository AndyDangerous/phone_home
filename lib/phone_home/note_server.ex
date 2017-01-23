defmodule PhoneHome.NoteServer do
  use GenServer
  import Supervisor.Spec

  defmodule State do
    defstruct sup: nil, worker_sup: nil, mfa: {PhoneHome.NoteWorker, :start_link, []}
  end

  ## Client API

  def start_link(sup) do
    GenServer.start_link(__MODULE__, sup, name: __MODULE__)
  end

  def create(note_params) do
    GenServer.cast(__MODULE__, {:new_note, note_params})
  end

  def check_timer do
    GenServer.cast(__MODULE__, :check_timer)
  end

  def update_workers(pids) do
    GenServer.call(__MODULE__, {:update_workers, pids})
  end

  ## Server Callbacks

  def init(sup) when is_pid(sup) do
    state = %State{sup: sup}
    init(state)
  end

  def init(%State{} = state) do
    # Process.flag(:trap_exit, true)
    send(self(), :start_note_supervisor)
    send(self(), :start_timer)
    {:ok, state}
  end

  def handle_call({:update_workers, pids}, _from, state) do
    pids
    |> Enum.each(fn(pid) -> update_worker(pid) end)
    {:reply, state, state}
  end

  def handle_cast({:new_note, %{"end_time" => end_time} = note_params}, state) do
    {:ok, worker_pid} = Supervisor.start_child(state.worker_sup, [note_params])
    Process.link(worker_pid)
    PhoneHome.Timer.create_entry(worker_pid, end_time)
    {:noreply, state}
  end

  def handle_cast(:check_timer, state) do
    pids = PhoneHome.Timer.retrieve_pids
    update_workers(pids)
    {:noreply, state}
  end

  # handle worker deaths

  def handle_info(:start_timer, state) do
    PhoneHome.Timer.initialize
    {:noreply, state}
  end

  def handle_info(:start_note_supervisor, %{sup: sup, mfa: mfa} = state) do
    {:ok, worker_sup} = Supervisor.start_child(sup, note_supervisor_spec(mfa))
    {:noreply, %{state | worker_sup: worker_sup}}
  end

  ## Helper Functions

  defp note_supervisor_spec(mfa) do
    opts = [restart: :temporary]
    supervisor(PhoneHome.NoteSupervisor, [mfa], opts)
  end

  defp update_worker(pid) do
    case PhoneHome.NoteWorker.update(pid) do
      :await_check_in ->
        :ok
      {:send_reminder, user_info} ->
        PhoneHome.Communicator.send_reminder(user_info)
      {:notify_contact, contact_info} ->
        PhoneHome.Communicator.notify_contact(contact_info)
    end
  end
end
