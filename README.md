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
  We are an engineering driven company, operating one of the world’s largest Ruby-based platform
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
command? Either way, adapting this API to whatever else we might need seemed
straight forward enough.


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
simplify testing for the following reasons:
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
files. I ran some basic benchmarks to confirm the script worked under load.
Here are the results:


Input file:
Note: you'll have to generate the input file. Please see the
[benchmark(#benchmark)] section for instructions.
```
  $ du -h ./input-files/benchmark-input.txt

  482M    ./input-files/benchmark-input.txt
```

Runtime stats:
The `real` column represents the execution time in seconds.

Jruby (v9.2.9):
```
                  user     system      total        real
  1 thread  422.850000   2.050000 424.900000 (151.946170)
  6 threads 470.680000   1.770000 472.450000 ( 62.124985)
```

MRI (v2.6.5):
```
                 user     system      total        real
  1 thread 242.121877   0.278335 242.400212 (242.406126)
```


# Usage
Run the following commands from the project root directory.

## Running The Script
```
  $ ruby main.rb -f input-files/large-sample-data.txt
```

If you'd like to run the script with extra threads pass in a desired threat
count with the `-t` flag:
```
  $ ruby main.rb -t 6 -f input-files/large-sample-data.txt
```

Be sure to use a Ruby engine such as `Jruby` to take full advantage of multiple threads.


## Running Unit Tests
```
  $ ruby lib/line_reader_tests.rb
```

## Benchmarks
Create an input file to use for benchmarking:
```
  $ ./benchmarks/create_input_file.sh <DESIRED FILE SIZE IN MEGABYTES
```

Then run the benchmark tests with the following:

```
  $ ruby ./benchmarks/main.rb
```
