# Exercise: WorkingWithMultipleProcesses-5

Repeat the two, changing `spawn_link` to `spawn_monitor`.

## Solution

See the [processes_exit.exs](./processes_exit.exs) and [processes_raise.exs](./processes_raise.exs) files for the full modules.

When running the implementation where the child does not raise an exception, we now see the _DOWN_ message.

```bash
cd lib/WorkingWithMultipleProcesses-5/
elixir -r processes_exit.exs  -e 'Processes.run()'
```

```txt
Starting parent process.
Parent process sleeping for 1 second.
Child process started. Sending message to parent.
Child process about to exit.
Parent process receive all.
Message: Hello!
Process #PID<0.104.0> died normally.
All messages received.
```

When running the version where the child does throw, we see the child die; however, the parent stays alive and wakes up to receive the message the child sent as well as the _DOWN_ message containing the error.

```bash
cd lib/WorkingWithMultipleProcesses-5/
elixir -r processes_raise.exs  -e 'Processes.run()'
```
