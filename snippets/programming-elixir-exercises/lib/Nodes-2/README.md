# Nodes - 2/3

```bash
cd lib/Nodes-2/
# not working
elixir -r ticker.ex  -e 'Ticker.start()'
```

```bash
# on 1st shell
iex --sname one
c("ticker.ex")

# on 2nd shell
iex --sname two
c("ticker.ex")

# back on 1st shell
Node.connect(:"two@galois")
Ticker.start()
Client.start()

# back on 2nd shell
Client.start()
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
