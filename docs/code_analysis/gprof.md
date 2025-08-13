# gprof Usage and Output

## Installation

```bash
sudo apt install binutils
```

## Command

```bash
# compile with profiling
clang -pg /tmp/gprof_demo.c -o /tmp/gprof_demo
/tmp/gprof_demo
# analyze
gprof /tmp/gprof_demo gmon.out | head -n 10
```

## Output

```text
Flat profile:
Each sample counts as 0.01 seconds.
 no time accumulated
  %   cumulative   self              self     total
 time   seconds   seconds    calls  Ts/call  Ts/call  name
  0.00      0.00     0.00        1     0.00     0.00  foo
```
