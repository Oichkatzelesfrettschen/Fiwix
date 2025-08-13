# lizard Usage and Output

## Installation

```bash
pip install lizard
```



## Command

```bash
lizard .
```

## Output Summary

```text
      48     16    326      2      54 fifo_open@20-73@./fs/pipefs/fifo.c
      45     17    313      2      46 data_proc_pid_maps@624-669@./fs/procfs/data.c
      70     16    447      2      79 data_proc_pid_stat@712-790@./fs/procfs/data.c
      96     26    600      3     110 procfs_lookup@19-128@./fs/procfs/namei.c
      89     19    484      6     101 minix_rename@705-805@./fs/minix/namei.c
     118     25    819      3     129 v1_minix_bmap@250-378@./fs/minix/v1_inode.c
      54     19    436      2      61 v1_minix_truncate@380-440@./fs/minix/v1_inode.c
     177     37   1253      3     190 v2_minix_bmap@254-443@./fs/minix/v2_inode.c
      88     29    748      2      96 v2_minix_truncate@445-540@./fs/minix/v2_inode.c
      93     28    526      5     113 do_namei@20-132@./fs/namei.c
      62     16    287      2      66 flock_inode@175-240@./fs/locks.c
      48     19    254      3      60 script_load@14-73@./fs/script.c
     119     39    835      6     221 elf_create_stack@65-285@./fs/elf.c
      85     16    642      1     104 elf_load_interpreter@287-390@./fs/elf.c
     144     26   1087      4     180 elf_load@405-584@./fs/elf.c
     289     93   1542      3     312 do_printk@87-398@./lib/printk.c
==========================================================================================
Total nloc   Avg.NLOC  AvgCCN  Avg.token   Fun Cnt  Warning cnt   Fun Rt   nloc Rt
------------------------------------------------------------------------------------------
     46325      25.6     5.9      161.2     1100           81      0.07    0.29

```
