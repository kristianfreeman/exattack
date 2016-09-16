defmodule ExAttack.Plug do
  alias Plug.Conn
  @behaviour Plug
  @options [:limit, :period, :lambda]

  defmodule ThrottledError do
    @moduledoc "Error raised when the request is throttled."
    message = "Retry later"
    defexception message: message, plug_status: 429
  end

  def init(opts) do
    Keyword.take(opts, @options)
  end

  def call(conn, opts) do
    case throttled(conn, opts) do
      :throttled  -> raise ThrottledError
      :ok -> conn
    end
  end

  def throttled(conn, opts) do
    [limit: limit, period: period, lambda: lambda] = opts
    ExAttack.Throttle.throttle("throttle", %{limit: limit, period: period}, lambda.(conn))
  end
end
