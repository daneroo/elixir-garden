# Exercise: WorkingWithMultipleProcesses-4

Do the same, but have the child raise an exception. What difference do you see in the tracing?

## Solution

See the [processes.exs](./processes.exs) file for the full module.

This time it looks like the child dies and takes the parent with it. Because the child died before the parent woke up and received the message it sent, the parent never receives the message because it dies while sleeping.

```bash
cd lib/WorkingWithMultipleProcesses-4/
elixir -r processes.exs  -e 'Processes.run()'
```

````txt
Starting parent process.
Parent process sleeping for 1 second.
Child process started. Sending message to parent.
Child process about to raise an Error.
** (EXIT from #PID<0.98.0>) an exception was raised:
    ** (RuntimeError) runtime error
        processes.exs:29: Processes.child/1```
````
