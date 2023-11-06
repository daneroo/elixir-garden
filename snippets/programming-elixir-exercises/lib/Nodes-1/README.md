# Nodes-1 exercises

## Connecting two nodes

shell 1:

```bash
cd lib/Nodes-1
mkdir -p node1  node2
cd node1
iex --sname node_one
```

shell 2:

```bash
cd lib/Nodes-1
cd node2

iex --sname node_two
  Node.self()
  Node.connect(:node_one@galois)
  Node.list()
```

## Running a function on a remote node

```elixir
#func = fn -> IO.inspect Node.self() end
func = fn -> IO.puts(Enum.join(File.ls!, ", ")) end
spawn(func)
Node.spawn(:node_one@galois, func)
Node.spawn(:node_two@galois, func)
```
