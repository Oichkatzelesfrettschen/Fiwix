# clang-format Usage and Output

## Installation

```bash
sudo apt install clang-format
```

## Command

```bash
clang-format kernel/main.c | head -n 20
```

## Output

```text
/*
 * fiwix/kernel/main.c
 *
 * Copyright 2018-2023, Jordi Sanfeliu. All rights reserved.
 * Distributed under the terms of the Fiwix License.
 */

#include <fiwix/asm.h>
#include <fiwix/buffer.h>
#include <fiwix/console.h>
#include <fiwix/cpu.h>
#include <fiwix/devices.h>
#include <fiwix/fs.h>
#include <fiwix/ipc.h>
#include <fiwix/irq.h>
#include <fiwix/kernel.h>
#include <fiwix/kexec.h>
#include <fiwix/keyboard.h>
#include <fiwix/kparms.h>
#include <fiwix/limits.h>
```
