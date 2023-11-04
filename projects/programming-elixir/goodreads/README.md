# Goodreads

Ch 13 - Your Turn - Goodreads

I replaced the NOAA xml parsing exercise with my own goodreads feed

## Operation

```bash
# compile then run
mix do compile, run -e 'Goodreads.main(["-h"])'
mix do compile, run -e 'Goodreads.main(["-s","read"])'

# lint
mix credo --strict
# test
mix test
mix test --trace
mix test --trace --cover

# build
mix escript.build
./goodreads

# documentation
mix docs
open doc/index.html
```

## Setup

```bash
mix new goodreads
cd goodreads
# and add credo (See top level README)
mix deps.get
```
