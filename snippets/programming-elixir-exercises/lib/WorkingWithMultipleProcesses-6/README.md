# Exercise: WorkingWithMultipleProcesses-6 and 7

In the _pmap_ code, I assigned the value of _self_ to the variable _me_ at the top of the method and then used _me_ as the target of the message returned by the spawned process. Why use a separate variable here?

## Solution

See the [parallel.exs](./parallel.exs) file for the full module.

Take a look at _line 6_ and notice that both the variable _me_ and the variable _self_ are used. Why might this be?

When that function is run, it is executed on the process that is spawned and thus, when we access _self_, it is going to return the _pid_ of the child process, not the parent process. So, in order to use the parent's _pid_ within the context of the child thread, we need to capture it in a separate variable.

```bash
cd lib/WorkingWithMultipleProcesses-6/
elixir -r parallel.exs  -e 'Parallel.pmap(1..10, &(&1 * &1))'
```

```txt
 elixir -r parallel.exs  -e 'Parallel.pmap(1..10, &(&1 * &1))'
Results: [49, 64, 9, 36, 4, 25, 81, 100, 16, 1]
```

Add a random sleep to see results out of order, when we match with `_pid` instead of `^pid`.

```bash
cd lib/WorkingWithMultipleProcesses-6/
elixir -r parallel_out_of_order.exs  -e 'Parallel.pmap(1..10, &(&1 * &1))'
```

With:

```elixir
receive do
  {_pid, result} -> result
end
```

```txt
Results: [36, 64, 81, 25, 4, 100, 16, 1, 9, 49]
```

But with:

```elixir
      receive do
        {^pid, result} -> result
      end
```

Results sorted as expected

```txt
Results: [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```
