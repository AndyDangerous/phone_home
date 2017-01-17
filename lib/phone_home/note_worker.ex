# recieves map of note data
# fire up statemachine 
# initialize with note details
# connect with timer

# receive messages from timer
# do the things (text/email)
# receive messages from users
# respond?


defmodule PhoneHome.NoteWorker do
  use GenServer

  defmodule State do
    defstruct user_phone: nil,
              end_time: nil,
              contact_phone: nil,
              contact_email: nil,
              trip_plan: nil
  end

  ## Client API

  def start_link(params) do
    GenServer.start_link(__MODULE__, params)
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

end
