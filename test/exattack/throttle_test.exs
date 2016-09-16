defmodule ExAttack.ThrottleTest do
  use ExUnit.Case
  doctest ExAttack

  @limit 5
  @period 1

  test "can do a request throttle" do
    throttled = ExAttack.Throttle.throttle("test1", %{limit: @limit, period: @period}, "foo")
    assert :ok == throttled
  end

  test "can set a value" do
    ExAttack.Throttle.cache("test2", 4, 1)
    cached_value = ExAttack.Throttle.check_limit("test2")
    assert 4 == cached_value
  end

  test "can be throttled" do
    for _ <- 0..@limit do
      ExAttack.Throttle.throttle("test3", %{limit: @limit, period: @period}, "foo")
    end

    throttled = ExAttack.Throttle.throttle("test3", %{limit: @limit, period: @period}, "foo")
    assert :throttled == throttled
  end

  test "cache expires" do
    for _ <- 0..@limit do
      ExAttack.Throttle.throttle("test4", %{limit: @limit, period: @period}, "foo")
    end

    :timer.sleep(:timer.seconds(@period))

    # Because we've waited for the specified period, we should be able to request again
    throttled = ExAttack.Throttle.throttle("test3", %{limit: @limit, period: @period}, "foo")
    assert :ok == throttled
  end
end
