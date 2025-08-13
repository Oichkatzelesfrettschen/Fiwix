# flawfinder Usage and Output

## Installation

```bash
sudo apt install flawfinder
```



## Command

```bash
flawfinder .
```

## Sample Findings

```text
Flawfinder version 2.0.19, (C) 2001-2019 David A. Wheeler.
Number of rules (primarily dangerous function names) in C/C++ ruleset: 222
Examining ./kernel/gdt.c
Examining ./kernel/process.c
Examining ./kernel/kexec.c
Examining ./kernel/idt.c
Examining ./kernel/pit.c
Examining ./kernel/irq.c
Examining ./kernel/cmos.c
Examining ./kernel/traps.c
Examining ./kernel/main.c
Examining ./kernel/syscalls.c
Examining ./kernel/pic.c
Examining ./kernel/sleep.c
Examining ./kernel/init.c
Examining ./kernel/multiboot.c
Examining ./kernel/cpu.c
Examining ./kernel/timer.c
Examining ./kernel/syscalls/getdents64.c
Examining ./kernel/syscalls/sigprocmask.c

```

## Summary

```text
ANALYSIS SUMMARY:

Hits = 278
Lines analyzed = 61341 in approximately 0.54 seconds (112790 lines/second)
Physical Source Lines of Code (SLOC) = 49703
Hits@level = [0]  10 [1]  76 [2] 186 [3]   0 [4]  13 [5]   3
Hits@level+ = [0+] 288 [1+] 278 [2+] 202 [3+]  16 [4+]  16 [5+]   3
Hits/KSLOC@level+ = [0+] 5.79442 [1+] 5.59322 [2+] 4.06414 [3+] 0.321912 [4+] 0.321912 [5+] 0.0603585
Dot directories skipped = 2 (--followdotdir overrides)
Minimum risk level = 1

Not every hit is necessarily a security vulnerability.
You can inhibit a report by adding a comment in this form:
// flawfinder: ignore
Make *sure* it's a false positive!
You can use the option --neverignore to show these.

There may be other security vulnerabilities; review your code!
See 'Secure Programming HOWTO'
(https://dwheeler.com/secure-programs) for more information.

```

