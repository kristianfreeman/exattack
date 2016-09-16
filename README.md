# ExAttack

ExAttack is WIP Plug middleware for server protection.
It's heavily based on [rack-attack](https://github.com/kickstarter/rack-attack/) in the Ruby world.
The eventual plan is to basically be feature-complete with that project.

Currently, ExAttack implements a throttler. Future plans are:
- Safelist
- Blocklist
- Fail2ban
- Allow2ban

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `exattack` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exattack, "~> 0.1.0"}]
    end
    ```

  2. Ensure `exattack` is started before your application:

    ```elixir
    def application do
      [applications: [:exattack]]
    end
    ```

## Usage

### Throttler

ExAttack should be added as a [Plug](https://github.com/elixir-lang/plug). Here's an example in Phoenix:

```elixir
  pipeline :browser do
    # ...
    plug ExAttack.Plug,
      limit: 5,
      period: 1,
      lambda: &MyApp.Throttler.throttler/1
  end
```

There are three options to provide to the plug: **limit**, which is the _maximum_ number of attempts a client can make in the **period** (in seconds).

The third option is a lambda that should return a specific client key. The obvious example is an IP address, but you can implement whatever you'd like. The above function, MyApp.Throttler.throttler/1, looks like this:

```elixir
defmodule MyApp.Throttler do
  def throttler(conn) do
    conn.remote_ip
    |> Tuple.to_list
    |> Enum.join(".")
  end
end
```

When a client is "throttled", the current response is a [429](https://httpstatuses.com/429).
The response might be customizable at some point.

## License

ExAttack, like other Elixir projects, is released under the Apache 2 License.
See LICENSE for more info.
