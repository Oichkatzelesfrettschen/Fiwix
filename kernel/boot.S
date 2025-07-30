/*
 * fiwix/kernel/boot.S
 *
 * Copyright 2018-2025, Jordi Sanfeliu.
 * Distributed under the terms of the Fiwix License.
 */

#define ASM_FILE 1

#include <fiwix/segments.h>
#include <fiwix/multiboot1.h>

/* Multiboot header flags */
#define MULTIBOOT_HEADER_FLAGS (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO)

/* CR0 control register flags */
#define CR0_MP 0x00000002  /* Monitor Coprocessor */
#define CR0_NE 0x00000020  /* Native x87 FPU mode */
#define CR0_WP 0x00010000  /* Write Protect */
#define CR0_AM 0x00040000  /* Alignment Checking */
#define CR0_PG 0x80000000  /* Paging */

#ifdef __TINYC__
    .data
#else
    .section .setup,"aw"
#endif
    .align 4
tmp_gdtr:
    .word (3*8 - 1)
tmp_gdta:
    .long tmp_gdt

    .align 4
tmp_gdt:
    /* Null descriptor */
    .word 0x0000
    .word 0x0000
    .word 0x0000
    .word 0x0000

    /* Kernel code segment */
    .word 0xFFFF              # limit low
    .word 0x0000              # base low
    .byte 0x00                # base mid
    .byte 0x9A                # P=1,DPL=0,S=1,TYPE=0xA (code)
    .byte 0xCF                # G=1,DB=1,AVL=0,limit high
    .byte GDT_BASE >> 24      # base high

    /* Kernel data segment */
    .word 0xFFFF
    .word 0x0000
    .byte 0x00
    .byte 0x92                # P=1,DPL=0,S=1,TYPE=0x2 (data)
    .byte 0xCF
    .byte GDT_BASE >> 24

#ifdef __TINYC__
    .text
#endif

    .align 4
multiboot_header:
    .long MULTIBOOT_HEADER_MAGIC
    .long MULTIBOOT_HEADER_FLAGS
    .long -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
    .long 0                   # header_addr
    .long 0                   # load_addr
    .long 0                   # load_end_addr
    .long 0                   # bss_end_addr
    .long 0                   # entry_addr
    .long 0                   # mode_type
    .long 0                   # width
    .long 0                   # height
    .long 0                   # depth

    .align 4
    .globl _start
_start:
    cli
#ifdef __TINYC__
    movl $tmp_gdt, %esi
    subl $PAGE_OFFSET, %esi
    movl $tmp_gdta, %edi
    subl $PAGE_OFFSET, %edi
    movl %esi, (%edi)
    movl $tmp_gdtr, %esi
    subl $PAGE_OFFSET, %esi
    lgdt (%esi)
#else
    lgdt tmp_gdtr
#endif
    movw $KERNEL_DS, %cx
    movw %cx, %ds
    movw %cx, %es
    movw %cx, %fs
    movw %cx, %gs
    movw %cx, %ss
    ljmp $KERNEL_CS, $setup_kernel

    .text
    .align 4
    .globl setup_kernel
setup_kernel:
    movl $(PAGE_OFFSET + 0x10000), %esp  # default stack
    pushl $0                              # clear EFLAGS
    popf

    pushl %ebx                           # save multiboot info ptr
    pushl %eax                           # save multiboot magic
    call setup_tmp_pgdir                 # setup temporary page directory
    movl %eax, %cr3

    movl %cr0, %eax
    andl $0x00000011, %eax               # clear caching, keep ET & PE
    orl  $CR0_PG,  %eax                  # enable paging
    orl  $CR0_AM,  %eax                  # alignment check
    orl  $CR0_WP,  %eax                  # write protect
    orl  $CR0_NE,  %eax                  # native FPU
    orl  $CR0_MP,  %eax                  # monitor coprocessor
    movl %eax, %cr0

    call bss_init                        # clear BSS
    call gdt_init                        # load final GDT
    call get_last_boot_addr

    popl %ecx                            # restore magic
    popl %ebx                            # restore multiboot ptr

    pushl %eax                           # last boot addr
    pushl %ebx                           # multiboot info ptr
    pushl %ecx                           # multiboot magic
    call start_kernel

    jmp cpu_idle                         # should not return

    .section .note.GNU-stack,"",@progbits