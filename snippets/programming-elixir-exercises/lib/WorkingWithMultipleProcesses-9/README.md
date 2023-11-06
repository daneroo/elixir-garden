# Exercise: WorkingWithMultipleProcesses-9

Take this scheduler code and update it to let you run a function that finds the number of times the word "cat" appears in each file in a given directory. Run one server process per file. The function _File.ls!_ returns the names of files in a directory, and _File.read!_ reads the contents of a file as a binary. Can you write it as a more generalized scheduler?

Run your code on a directory with a reasonable number of files (maybe around 100) so you can experiment with the effects of concurrency.

## Solution

See the [word_count.exs](./word_count.exs) file for the full modules.

For the purposes of testing I generated 100 files with somewhat randomized content. Each file contains 15000 sentences and there is a 25% chance that each sentence contains the word "cat". These files can be generated using the [generate_test_files.py](./generate_test_files.py) script.

```bash
cd lib/WorkingWithMultipleProcesses-9/
elixir -r word_count.exs  -e 'Runner.run()'
# Create the file (once)
elixir -r word_count.exs  -e 'TextFileGenerator.main()'

# bash equivalent:
for file in test_files/file???.txt; do
  echo -n "$file: "
  grep -o 'cat' "$file" | wc -l
done
```

```txt
Counting occurrences of 'cat' in all files in test_files/ directory
Timing with 1..12 processes

 #   time (ms)
 1     116.37
 2     111.84
 3     57.37
 4     44.18
 5     34.65
 6     35.00
 7     33.14
 8     30.03
 9     30.15
10     28.63
11     28.12
12     28.70
```
