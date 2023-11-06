# Nodes - 2/3

```bash
cd lib/Nodes-2/
iex --sname one -e 'Code.compile_file("ticker.ex"); Ticker.start(); Client.start()'
# sleep1 second so Node.connect can complete
iex --sname two -e 'Code.compile_file("ticker.ex"); Node.connect(:"one@galois"); :timer.sleep(1000); Client.start()'
iex --sname three -e 'Code.compile_file("ticker.ex"); Node.connect(:"one@galois"); :timer.sleep(1000); Client.start()'
```

```txt
iex(one@galois)3> Ticker.start()
:yes
iex(one@galois)4> Client.start()
registering #PID<0.131.0>
{:register, #PID<0.131.0>}
tick
send tick to client #PID<0.131.0>
tock in client
tick
send tick to client #PID<0.131.0>
tock in client
tick
send tick to client #PID<0.131.0>
tock in client
tick
send tick to client #PID<0.131.0>
tock in client
```

```txt
iex(two@galois)10> Client.start()
{:register, #PID<0.133.0>}
tock in client
tock in client
tock in client
```
