# Exercise: WorkingWithMultipleProcesses-8

Run the Fibonacci code on your machine. Do you get comparable timings? If your machine has multiple cores and/or processors, do you see improvements in the timing as we increase the application's concurrency?

## Solution

See the [fibonacci.exs](./fibonacci.exs) file for the full modules.

So, I see no performance increase whatsoever:

```bash
cd lib/WorkingWithMultipleProcesses-6/
elixir -r fibonacci.exs  -e 'Runner.run()'
```

```txt
Calculating fibonaci number (39) 20 times
Timing with 1..12 processes

 #   time (s)
 1     9.03
 2     4.70
 3     3.42
 4     3.26
 5     2.58
 6     2.28
 7     1.93
 8     1.90
 9     1.88
10     1.49
11     1.55
12     1.55
```
