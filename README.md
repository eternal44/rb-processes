Hi James,

I heard you had a great phone interview! As a part our screening process, we administer a take home programming question. Things to keep in mind before submitting your response:

1. Please take your time and respond to the question.

2. Choose any language you are comfortable with. 

3. Please provide steps to run the program.

4. Think about the design/structure/testability of the program. 

5. Please sign and return our application and NDA with your response. You will receive a separate email from DocuSign with these documents.

Once your response has been submitted, the team will review it and I will get back to you regarding next steps. 

We're always available if you have questions, so if you have any please send us a note. 

Please reply stating that you have received this email. 

Best,

Taylor 




cat /proc/cpuinfo | grep processor | wc -l

require 'parallel'
require 'benchmark'
mutex = Mutex.new

add numbres to file
```
  $ ruby -e '(1..100000).each { |i| puts "This is line number #{i}"}' > large_file.txt
```

proof of concept
```
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
