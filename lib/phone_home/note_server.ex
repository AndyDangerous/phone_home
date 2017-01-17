defmodule PhoneHome.NoteServer do
  use GenServer
  import Supervisor.Spec
  require IEx

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

  def handle_cast({:new_note, %{end_time: end_time} = note_params}, state) do
    {:ok, worker_pid} = Supervisor.start_child(state.worker_sup, [note_params])
    Process.link(worker_pid)
    # PhoneHome.Timer.new_time(worker_pid, end_time)
    {:noreply, state}
  end

  # handle worker deaths

  def handle_info(:start_timer, %{sup: sup} = state) do
    {:ok, _timer_sup} = Supervisor.start_child(sup, timer_spec())
    {:noreply, state}
  end

  def handle_info(:start_note_supervisor, %{sup: sup, mfa: mfa} = state) do
    {:ok, worker_sup} = Supervisor.start_child(sup, note_supervisor_spec(mfa))
    {:noreply, %{state | worker_sup: worker_sup}}
  end

  ## Helper Functions

  defp timer_spec do
    worker(PhoneHome.Timer, [])
  end

  defp note_supervisor_spec(mfa) do
    opts = [restart: :temporary]
    supervisor(PhoneHome.NoteSupervisor, [mfa], opts)
  end
end
