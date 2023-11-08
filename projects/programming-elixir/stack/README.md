# Stack

Stack OTP example in Programming Elixir 1.6 by Dave Thomas.

## Usage

```bash
$ iex -S mix

{:ok, pid} = GenServer.start_link(Stack.Server,["cat",3,2,1])
GenServer.call(pid, :pop)
GenServer.cast(pid, {:push, 42})
```
