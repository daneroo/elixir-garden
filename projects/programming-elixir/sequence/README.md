# Sequence

First OTP example in Programming Elixir 1.6 by Dave Thomas.

## Usage

```bash
$ iex -S mix

Sequence.Server.factors(12)
Sequence.Server.factors(9973)

{:ok, pid} = GenServer.start_link(Sequence.Server,100)
GenServer.call(pid,:next_number)
GenServer.cast(pid,{:increment_number,5})
GenServer.call(pid,{:set_number,999})
GenServer.call(pid,{:factors_number,9973})

# debug exercises
{:ok, pid} = GenServer.start_link(Sequence.Server,100,[debug: [:trace]])
{:ok, pid} = GenServer.start_link(Sequence.Server,100,[debug: [:statistics]])
:sys.statistics(pid,:get)
:sys.get_status(pid)

```
