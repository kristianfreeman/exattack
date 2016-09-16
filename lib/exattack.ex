defmodule ExAttack do
  use Supervisor

  def start(_type, _args) do
    ExAttack.start_link
  end

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Cachex, [:exattack_cache, []])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
