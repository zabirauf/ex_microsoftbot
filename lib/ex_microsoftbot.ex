defmodule MicrosoftBot.Client do
  alias MicrosoftBot.Models, as: Models

  @spec send_message(Models.AuthData.t, Models.Message.t) :: Models.Message.t
  def send_message(auth_data, message) do
    
  end

  @spec get_user_data(Models.AuthData.t, String.t, String.t) :: Models.BotData.t
  def get_user_data(auth_data, bot_id, user_id) do
    
  end

  @spec set_user_data(Models.AuthData.t, String.t, String.t, map) :: Models.BotData.t
  def set_user_data(auth_data, bot_id, user_id, data) do
    
  end

  @spec get_conversation_data(Models.AuthData.t, String.t, String.t) :: Models.BotData.t
  def get_conversation_data(auth_data, bot_id, conversation_id) do
    
  end

  @spec set_conversation_data(Models.AuthData.t, String.t, String.t, map) :: Models.BotData.t
  def set_conversation_data(auth_data, bot_id, conversation_id, data) do
    
  end

  @spec get_per_user_conversation_data(Models.AuthData.t, String.t, String.t, String.t) :: Models.BotData.t
  def get_per_user_conversation_data(auth_data, bot_id, conversation_id, user_id) do
    
  end

  @spec set_per_user_conversation_data(Models.AuthData.t, String.t, String.t, String.t, map) :: Models.BotData.t
  def set_per_user_conversation_data(auth_data, bot_id, conversation_id, user_id, data) do
    
  end

end
