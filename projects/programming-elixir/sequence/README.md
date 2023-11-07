# Sequence

First OTP example in Programming Elixir 1.6 by Dave Thomas.

## Usage

```bash
$ iex -S mix

Sequence.Server.factors(12)
Sequence.Server.factors(9973)

{:ok, pid} = GenServer.start_link(Sequence.Server,100)
GenServer.call(pid,:next_number)
GenServer.call(pid,{:set_number,999})
GenServer.call(pid,{:factors_number,9973})
```
