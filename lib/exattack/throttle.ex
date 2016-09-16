defmodule ExAttack.Throttle do
  def throttle(key, %{limit: limit, period: period}, throttle_key) do
    cache_key = "ex_attack:#{:os.system_time(:seconds)}:#{key}:#{throttle_key}"
    cached_value = check_limit(cache_key)

    status = case cached_value > limit do
      true  -> :throttled
      false -> :ok
    end

    cache(cache_key, cached_value + 1, period)
    status
  end

  def check_limit(key) do
    case Cachex.get(:exattack_cache, key) do
      {:missing, nil} -> 0
      {:ok, value} -> value
    end
  end

  def cache(key, value, period) do
    Cachex.set(:exattack_cache, key, value, ttl: :timer.seconds(period))
  end
end
