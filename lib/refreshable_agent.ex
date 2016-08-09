defmodule ExMicrosoftBot.RefreshableAgent do

  @callback get_refreshed_state(any, any) :: any
  @callback time_to_refresh_after_in_seconds(any) :: integer

  @doc false
  defmacro __using__(_) do
    quote location: :keep do
      require Logger
      @behaviour ExMicrosoftBot.RefreshableAgent
      use GenServer

      ################################################
      ##### Functions to interact with GenServer #####
      ################################################

      def start_link() do
        start_link([])
      end

      def start_link(args) do
        GenServer.start_link(__MODULE__, args, name: __MODULE__)
      end

      ###############################
      ##### GenServer Callbacks #####
      ###############################

      def init(args) do
        state = get_refreshed_state_and_schedule_refresh(args, nil)
        |> Map.merge(%{original_args: args}, fn(_k1, _v1, v2) -> v2 end)

        {:ok, state}
      end

      def handle_call(:get_state, _from, %{state: mod_state} = state) do
        Logger.debug "refreshable_agent: handle_call/3 -> :get_state -> #{inspect(state)}"
        {:reply, mod_state, state}
      end

      def handle_call(:force_refresh, _from, %{timer_ref: timer_ref} = state) do
        # Cancel the timer, send message to self to refresh and reply with :ok
        Logger.debug "refreshable_agent: handle_call/3 -> :force_refresh"

        Process.cancel_timer(timer_ref)
        send(self(), :refresh)

        {:reply, :ok, state}
      end

      def handle_info(:refresh, %{state: mod_state, original_args: args} = state) do
        new_state = get_refreshed_state_and_schedule_refresh(args, mod_state)
        |> Map.merge(state, fn(_k, v1, _v2) -> v1 end)

        {:noreply, new_state}
      end

      ###############################
      ####### Helper functions ######
      ###############################

      @spec get_state() :: any
      defp get_state() do
        GenServer.call(__MODULE__, :get_state)
      end

      @spec force_refresh_state() :: :ok
      defp force_refresh_state() do
        GenServer.call(__MODULE__, :force_refresh)
      end

      @spec get_refreshed_state_and_schedule_refresh(any, any) :: Map.t
      defp get_refreshed_state_and_schedule_refresh(args, old_state) do
        Logger.debug "RefreshableAgent.get_refreshed_state_and_schedule_refresh/2 -> #{inspect(old_state)}"

        updated_mod_state = get_refreshed_state(args, old_state)
        Logger.debug "RefreshableAgent.get_refreshed_state_and_schedule_refresh/2 -> #{inspect(updated_mod_state)}"

        timer_ref = time_to_refresh_after_in_seconds(updated_mod_state)
        |> Kernel.*(1000) # Converting to ms
        |> schedule_next_refresh

        %{state: updated_mod_state, timer_ref: timer_ref}
      end

      defp schedule_next_refresh(refresh_time_in_seconds) do
        Logger.debug "RefreshableAgent.schedule_next_refresh/1 -> #{refresh_time_in_seconds}"
        Process.send_after(__MODULE__, :refresh, refresh_time_in_seconds)
      end
    end
  end
end
