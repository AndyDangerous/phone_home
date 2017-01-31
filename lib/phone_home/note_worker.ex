defmodule PhoneHome.NoteWorker do
  use GenServer

  defmodule State do
    defstruct user_phone: nil,
              end_time: nil,
              contact_phone: nil,
              contact_email: nil,
              trip_plan: nil,
              note_state: :in_progress
  end

  ## Client API

  def start_link(params) do
    GenServer.start_link(__MODULE__, params, [name: String.to_atom(params[:user_phone])])
  end

  def status(phone_number) do
    GenServer.call(String.to_atom(phone_number), :status)
  end

  def safe(phone_number) do
    GenServer.call(String.to_atom(phone_number), :safe)
  end

  def update(phone_number) do
    GenServer.call(String.to_atom(phone_number), :update)
  end

  ## Server Callbacks

  def init(params) do
    state = %State{
      user_phone: params[:user_phone],
      end_time: params[:end_time],
      contact_phone: params[:contact_phone],
      contact_email: params[:contact_email],
      trip_plan: params[:trip_plan],
    }
    {:ok, state}
  end

  def handle_call(:safe, _from, state) do
    new_state = %{state | note_state: :safe}
    {:reply, {:ok, :safe}, new_state}
  end

  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:update, _from, %{note_state: :in_progress} = state) do
    new_state = %{state | note_state: :await_check_in}
    {:reply, :await_check_in, new_state}
  end

  def handle_call(:update, _from, %{note_state: :await_check_in} = state) do
    new_state = %{state | note_state: :send_reminder}
    {:reply, {:send_reminder, %{phone: state.user_phone}}, new_state}
  end

  def handle_call(:update, _from, %{note_state: :send_reminder} = state) do
    new_state = %{state | note_state: :notify_contact}
    contact_info = %{
      contact_phone: state.contact_phone,
      contact_email: state.contact_email,
      trip_plan: state.trip_plan
    }
    {:reply, {:notify_contact, contact_info}, new_state}
  end
end
