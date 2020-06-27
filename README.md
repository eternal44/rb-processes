2. Choose any language you are comfortable with. 

3. Please provide steps to run the program.

4. Think about the design/structure/testability of the program. 
since we may be using this function on larger files I opted to use threads.
Threads instead of processes to allow for shared memory address between threads
so we can do aggregate functions like `count` if we need in the future.

created a large file to test
```
  $ ruby -e '(1..100000).each { |i| puts "This is line number #{i}"}' > large_file.txt
```

tuned thread count by:
TODO: add

proof of concept
```
  require 'parallel'
  require 'benchmark'
  mutex = Mutex.new

  count = 0
  puts Benchmark.measure {
    Parallel.each(
      File.open('large_file.txt').each_line,
      in_threads: 6
    ) { |line|
      if (line * 10000) =~ /9999/
        mutex.lock

        count += 1

        mutex.unlock
      end
    }
  }

  p count
```



## Results
Need to run with threads for shared memory address (find correct term).
We can parralelize operations with processes but didn't want to deal with the hassle of <TODO: how to 
communicate between processes? find terminology>
  see here
  https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/

cat /proc/cpuinfo | grep processor | wc -l

MRI (C-Ruby)
17 sec
```
#########
# JRUBY #
#########
# with threads:
# 1 - 29 s
# 4 - 13 sec
# 6 - 7 sec
# 8 - 6 sec

```
Just for curiosity I tried running this with processes
```
# with processes:
# 1 - 18 s
# 4 - 6 sec
```


reduced the scope of the problem by asserting basic assumptions with `LineReaderExceptions::BracketError`.

wrote tests for non-printable lines

spot checked printed and non-printed
uxpvoytxfazjjhi[qogwhtzmwxvjwxreuz]zduoybbzxigwggwu[lamifchqqwbphhsqnf]qrjdjwtnhsjqftnqsk[bsqinwypsnnvougrs]wfmhtjkysqffllakru




