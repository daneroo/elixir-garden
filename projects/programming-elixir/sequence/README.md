# Sequence

First OTP example in Programming Elixir 1.6 by Dave Thomas.

## Usage

```bash
$ iex -S mix

Sequence.Server.next_number()
Sequence.Server.increment_number(5)
Sequence.Server.next_number()
Sequence.Server.set_number(999)
Sequence.Server.next_number()
Sequence.Server.next_number()

Sequence.Server.factors(12)
Sequence.Server.factors(9973)


# debug exercises
{:ok, pid} = GenServer.start_link(Sequence.Server,100,[debug: [:trace]])
{:ok, pid} = GenServer.start_link(Sequence.Server,100,[debug: [:statistics]])
:sys.statistics(pid,:get)
:sys.get_status(pid)

```
