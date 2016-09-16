defmodule ExAttack.Cache do
  @moduledoc """
  ExAttack.Cache is a cache supervisor.
  """

  # Custom status type
  # h/t zackehh/cachex
  @type status :: :ok | :error | :missing

  use Application

  @doc """
  Start the supervision tree for ExAttack.
  """
  @spec start(any, any) :: { atom, pid }
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Cachex, [:exattack_cache, []])
    ]

    opts = [strategy: :one_for_one, name: ExAttack.Cache]
    Supervisor.start_link(children, opts)
  end
end
