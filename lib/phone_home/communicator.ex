defmodule PhoneHome.Communicator do
  def check_in_with_user({_phone_number, _message} = check_in) do
    PhoneHome.SmsController.check_in_with_user(check_in)
  end

  def check_in_from_user(phone_number) do
    PhoneHome.NoteServer.check_user_in(phone_number)
  end
end
