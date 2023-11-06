# Exercise: WorkingWithMultipleProcesses-3

Use _spawn_link_ to start a process, and have that process send a message to the parent and then exit immediately. Meanwhile, sleep for 500 ms in the parent, then receive as many messages as are waiting. Trace what you receive.

Does it matter that you weren't waiting for the notification from the child when it exited? **No!**

## Solution

See the [processes.exs](./processes.exs) file for the full module.

It seems that it does matter that we weren't waiting for the message when it was sent. When executing the code:

```bash
cd lib/WorkingWithMultipleProcesses-3/
elixir -r processes.exs  -e 'Processes.run()'
```

```txt
Starting parent process.
Parent process sleeping for 1 second.
Child process started. Sending message to parent.
Child process about to exit.
Parent process receive all.
Message: Hello!
All messages received.
```

We only receive one message; on the second _receive_ we timeout while waiting.
