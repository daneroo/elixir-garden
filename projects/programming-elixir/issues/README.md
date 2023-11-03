# Issues

Programming Elixir (by Dave Thomas) project for Fetching GitHub Issues

This will fetch and format issues from a GitHub repository.

- <https://api.github.com/repos/daneroo/elixir-garden/issues>
- <https://api.github.com/repos/elixir-lang/elixir/issues>

## Operation

```bash
# lint
mix credo --strict
# test
mix test
mix test --trace
mix test --trace --cover

# build
mix escript.build
./issues --help
./issues elixir-lang elixir
./issues elixir-lang elixir 10
./issues daneroo elixir-garden

# documentation
mix docs
open doc/index.html
```
