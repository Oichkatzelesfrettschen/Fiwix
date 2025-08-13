================================================
  NLOC    CCN   token  PARAM  length  location  
------------------------------------------------
       9      2     64      3      10 semundo_ops@24-33@kernel/syscalls/semop.c
      36      9    212      0      37 semexit@35-71@kernel/syscalls/semop.c
     131     39    812      3     153 sys_semop@73-225@kernel/syscalls/semop.c
       6      1     18      0       6 ipc_init@25-30@kernel/syscalls/ipc.c
      19      8     95      2      31 ipc_has_perms@32-62@kernel/syscalls/ipc.c
3 file analyzed.
==============================================================
NLOC    Avg.NLOC  AvgCCN  Avg.token  function_cnt    file
--------------------------------------------------------------
     64       0.0     0.0        0.0         0     include/fiwix/sem.h
    187      58.7    16.7      362.7         3     kernel/syscalls/semop.c
    136      12.5     4.5       56.5         2     kernel/syscalls/ipc.c

=======================================================================================================
!!!! Warnings (cyclomatic_complexity > 1 or length > 1 or nloc > 1000000 or parameter_count > 100) !!!!
================================================
  NLOC    CCN   token  PARAM  length  location  
------------------------------------------------
       9      2     64      3      10 semundo_ops@24-33@kernel/syscalls/semop.c
      36      9    212      0      37 semexit@35-71@kernel/syscalls/semop.c
     131     39    812      3     153 sys_semop@73-225@kernel/syscalls/semop.c
       6      1     18      0       6 ipc_init@25-30@kernel/syscalls/ipc.c
      19      8     95      2      31 ipc_has_perms@32-62@kernel/syscalls/ipc.c
==========================================================================================
Total nloc   Avg.NLOC  AvgCCN  Avg.token   Fun Cnt  Warning cnt   Fun Rt   nloc Rt
------------------------------------------------------------------------------------------
       387      40.2    11.8      240.2        5            5      1.00    1.00
