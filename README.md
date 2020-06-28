# Prompt
I'm adding portions of the prompt here for easy reference.
```
  You have been provided a file with a list of strings. Each string is on a new line.
  The size of the file could be anywhere between 5MB - 1000MB.

  Write a program/script to count and print lines which have the following pattern

  Any 4 char sequence which has a pair of two different characters followed by the reverse of that pair
  e.g xaax or raar. The string is not considered valid if the pattern above exist in square brackets.

  For example:

  rttr[mnop]qrst this is valid   (rttr outside square brackets).
  efgh[baab]ommo this is invalid (baab is within brackets, ommo outside brackets).
  bbbb[qwer]ereq this is invalid (bbbb is invalid, since the middle two characters should be different.
  irttrj[asdfgh]zxcvbn this is valid (rttr is outside square brackets).

  2. Choose any language you are comfortable with. 

  3. Please provide steps to run the program.

  4. Think about the design/structure/testability of the program. 
```


# Design
### Language Choice
Golang seemed like a natural choice because of it's `channel` feature but I
ultimately decided against it. As per the job description: 

```
  We are an engineering driven company, operating one of the world’s largest
  Ruby-based platform
```

It looked like there'd be a high probability I'd be working with Ruby so I
wanted to showcase what I could do with it.

### API
Understandng the context in which the script will run is an important first step.
For the sake of time and for this exercise, however, I made some assumptions
regarding it's usecase and opted to write a CLI tool since the script needs
to:
- read large files 
- print values instead of returning them

Maybe it's intended use would be to pipe the STDOUT into another executable
command? Either way, rewriting the API to fit whatever other usecase should
not be a problem due to it's structure.


# Structure
The script is composed of smaller parts that are composed together to
address the required functionality of the assignment. I could have built the
script to be more configurable but felt that would be over engineered for the
scope of this exercise.

Here are the main parts of the script:
- validate a single line
- file reader to read each line
- a CLI layer for the user to interact with 


# Testability
### Strategies
Another intuitive reason to structure the script in composable parts is to
simplify testing it's different parts:
- writing unit tests for the single line validation function is intuitive
- the `File.open` function I'm using is a Kernel function so I opted not to test it
- handling CLI inputs can be easily tested manually

After I implemented unit tests I then used the `small-sample-data.txt` from the
prompt to spot check that the correct line was printed.

Based on the sample input files and for the sake of time I wrote the script
with the following assertions:
- each bracket contains atleast 4 characters
- no brackets are nested
- all open brackets must be paired with a closing bracket

and implemented a validation layer to detect any unexpected bracket
patterns in a line. Please see the `#check_for_bracket_errors` in the
[lib/line_reader.rb(./lib/line_reader.rb)] file for reference.


### Performance
The more difficult requirement to test was the script's ability to scan larger
files. I knew Ruby's `File.open` function would be able to handle files of any size
but I got curious about optimizing it's performance.  I ran some basic
benchmarks to confirm the script worked under load with 2 different Ruby
engines:

MRI - to simulate the most probable selection in production
Jruby - to explore the advantages of using threaded processes

Read on to see the preliminary results I found.

#### Laptop specs:
```
Ubuntu 18.04.4
8 gb memory
Intel i7-8565U CPU @ 1.80GHz (8 cores)
```

#### Input file
We'll need a larger file to run these benchmarks on. I generated these files
with a basic script that appended the `large-sample-data.txt` file to another
file `n` number of times. Please see the [benchmark(#benchmark)] section for
usage instructions.

#### Benchmark #1
NOTE: The `real` column below represents the script's run time in seconds.

```
  $ du -h ./input-files/benchmark-input.txt

  482M    ./input-files/benchmark-input.txt
```

Jruby (v9.2.9)run time:
```
                  user     system      total        real
  1 thread  422.850000   2.050000 424.900000 (151.946170)
  6 threads 470.680000   1.770000 472.450000 ( 62.124985)
```

MRI (v2.6.5)run time:
```
                 user     system      total        real
  1 thread 242.121877   0.278335 242.400212 (242.406126)
```

#### Benchmark #2

```
  $ du -h ./input-files/benchmark-input.txt

  964M    ./input-files/benchmark-input.txt
```

MRI (v2.6.5)run time:
```
  $ ruby ./benchmarks/main.rb

                  user     system      total        real
  1 thread  479.971765   0.671950 480.643715 (480.834031)

```

Jruby (v9.2.9)run time:
```
  $ ruby -J-Xmx3000M ./benchmarks/main.rb

                  user     system      total        real
  1 thread  1029.900000   4.970000 1034.870000 (353.052178)
  6 threads 1072.650000   3.350000 1076.000000 (139.380866)
```

#### Results
As expected, a multi-threaded approach will yield faster runtimes but at the
cost of more compute resources. You'll also notice I needed to increase the
memory cap for Jruby on the ~1gb benchmark due to it's default memory cap of
1904MB.

There are a few more interesting observations I made from these benchmarks but
for the sake of brevity I'll forego doing so here. For additional benchmark
metrics please see the [`htop` screenshots](./benchmarks/screenshots/).


# Usage
Run the following commands from the project root directory. If you're using
Jruby and encounter this error message:

```
  Error: Your application used more memory than the automatic cap of 1904MB.
  Specify -J-Xmx####M to increase it (#### = cap size in MB).
```

You can temporarily increase that memory cap with the suggested flag from that
error message:
```
  $ ruby -J-Xmx3000M main.rb -t 6 -f <YOUR FILE PATH>
```


### Running The Script
```
  $ ruby main.rb -f input-files/large-sample-data.txt
```

Use the `-t` flag to run the script with more threads:
```
  $ ruby main.rb -t 6 -f input-files/large-sample-data.txt
```


### Running Unit Tests
```
  $ ruby lib/line_reader_tests.rb
```


### Benchmarks
Create an input file to use for benchmarking:
```
  $ ./benchmarks/create_input_file.sh <DESIRED FILE SIZE IN MEGABYTES>
```

Then run the benchmark tests with the following:

```
  $ ruby ./benchmarks/main.rb
```
