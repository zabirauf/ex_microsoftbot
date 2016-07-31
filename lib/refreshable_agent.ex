defmodule ExMicrosoftBot.RefreshableAgent do
  require Logger

  @callback get_refreshed_state(any, any) :: any
  @callback time_to_refresh_after_in_seconds(any) :: integer

  @doc false
  defmacro __using__(_) do
    quote location: :keep do
      @behaviour ExMicrosoftBot.RefreshableAgent
      use GenServer

      ################################################
      ##### Functions to interact with GenServer #####
      ################################################

      def start_link(args) do
        GenServer.start_link(__MODULE__, args, name: __MODULE__)
      end

      @doc """
      Get the state
      """
      @spec get_state() :: any
      def get_state() do
        GenServer.call(__MODULE__, :get_state)
      end

      ###############################
      ##### GenServer Callbacks #####
      ###############################

      def init(args) do
        state = get_refreshed_state_and_schedule_refresh(args, nil)
        |> Keyword.merge([original_args: args], fn(_k1, _v1, v2) -> v2 end)

        {:ok, state}
      end

      def handle_call(:get_state, _from, [state: mod_state] = state) do
        {:reply, mod_state, state}
      end

      def handle_info(:refresh, [state: mod_state, original_args: args] = state) do
        new_state = get_refreshed_state_and_schedule_refresh(args, mod_state)
        |> Keyword.merge(state, fn(_k, v1, _v2) -> v1 end)

        {:noreply, new_state}
      end

      ###############################
      ####### Helper functions ######
      ###############################

      @spec get_refreshed_state_and_schedule_refresh(any, any) :: Keyword.t
      defp get_refreshed_state_and_schedule_refresh(args, old_state) do
        update_mod_state = get_refreshed_state(args, old_state)

        timer_ref = time_to_refresh_after_in_seconds(update_mod_state)
        |> Kernel.*(1000) # Converting to ms
        |> schedule_next_refresh

        [state: update_mod_state, timer_ref: timer_ref]
      end

      defp schedule_next_refresh(refresh_time_in_seconds) do
        Process.send_after(__MODULE__, :refresh, refresh_time_in_seconds)
      end
    end
  end
end
