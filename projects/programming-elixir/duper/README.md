# Duper

File deduper example form Programming Elixir 1.6 by Dave Thomas.

## Tests are broken

Because mix test starts the application.

## Results `photo/catou`

Deduping all photos in my `photo/catou` directory, found 91 dups/ 23379 files:

Real Time Execution (in seconds)

001 workers | ████████████████████████████████████████████████████████ 1m15.099s
002 workers | ██████████████████████████████████████████ 47.573s
003 workers | █████████████████████████████████ 35.567s
005 workers | █████████████████████████ 25.115s
010 workers | ████████████████ 16.916s
050 workers | ███████████ 12.993s
100 workers | ███████████ 12.601s

| Workers | Real Time |
| ------- | --------- |
| 1       | 1m15.099s |
| 2       | 0m47.573s |
| 3       | 0m35.567s |
| 5       | 0m25.115s |
| 10      | 0m16.916s |
| 50      | 0m12.993s |
| 100     | 0m12.601s |
