# Elixir Garden

Gathering my initial experiments with Elixir.

See Obsidian for learning plan

## Project Ideas

- Compare audiobooks whisper and ebook
- Podcast aggregator, summarizer, and indexer
- Port qcic
  - Monitor self, ted1k and mirror

## Initial goals

- [ ] simple cluster, w/linux and MacOS
  - [ ] Phoenix LiveView for monitoring

## Sub Project setup

When you `mix new`: if you want linter support add this dependency to `mix.exs`:

```elixir
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
```

## Setup

- [VSCode ElixirLS extension](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls)
- [VSCode Credo (Linter) extension](https://marketplace.visualstudio.com/items?itemName=pantajoe.vscode-elixir-credo)
- Install with homebrew

```sh
brew install elixir
# Elixir: To get proper :observer.start to work
brew reinstall --build-from-source wxwidgets


❯ elixir -v
Erlang/OTP 26 [erts-14.0.2] [source] [64-bit] [smp:10:10] [ds:10:10:10] [async-threads:1] [jit] [dtrace]
Elixir 1.15.7 (compiled with Erlang/OTP 26)
```

## References

Also see Obsidian (for learning plan)

- Programming Elixir ≥ 1.6, Dave Thomas, support repos
  - programming-elixir: <https://github.com/herminiotorres/programming-elixir>
  - elixir-exercises: <https://github.com/carlos4ndre/elixir-exercises>
  - programming-elixir-exercises: <https://github.com/pcewing/programming-elixir-exercises>
- [My O'Reilly Elixir Playlist](https://learning.oreilly.com/playlists/996eb216-4907-4b09-94f3-c2113a506152/)
- [Elixir School](https://elixirschool.com/en/)
  - [Podcast](https://elixirschool.com/en/podcasts)
- [Groxio](https://grox.io/elixir-video-courses/for-individuals)
