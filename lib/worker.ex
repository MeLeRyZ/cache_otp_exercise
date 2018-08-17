defmodule Cache.Worker do # Exercise from OTP guidebook
    use GenServer

    @name CW #stores the name of the server
    # deleted funcname(pid)
    # passing @name instead of server's pid

    ## CLIENT API
    def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
    end

    def write(key, names) do
        GenServer.call(@name, {:write, key, names})
    end

    def read(key) do
        GenServer.call(@name, {:read, key}) # calls tag from server's pid
    end

    def exist?(key) do
        GenServer.call(@name, {:exist?, key})
    end

    def delete(key) do
        GenServer.cast(@name, {:delete, key})
    end

    def clear do
        GenServer.cast(@name, :clear)
    end


    ## SERVER API
    def init(:ok) do
        {:ok, %{}}
    end

    def handle_call({:write, key, names}, _from, cache) do
        new_cache = Map.put(cache, key, names)
        {:reply, :ok, new_cache}
      end

      def handle_call({:read, key}, _from, cache) do
        info = Map.get(cache, key)
        {:reply, info, cache}
      end

      def handle_call({:exist?, key}, _from, cache) do
        info = Map.has_key?(cache, key)
        {:reply, info, cache}
      end

      def handle_cast({:delete, key}, cache) do
        new_cache = Map.delete(cache, key)
        {:noreply, new_cache}
      end

      def handle_cast(:clear, _cache) do
          {:noreply, %{}}
      end

end
