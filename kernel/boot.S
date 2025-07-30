/*

fiwix/kernel/boot.S

Copyright 2018-2021, Jordi Sanfeliu. All rights reserved.
Distributed under the terms of the Fiwix License.
*/

#define ASM_FILE 1
#include <fiwix/segments.h>
#include <fiwix/multiboot1.h>
#define MULTIBOOT_HEADER_FLAGS MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO
/* flags for CR0 (control register) /
#define CR0_MP 0x00000002 / bit 01 -> enable monitor coprocessor /
#define CR0_NE 0x00000020 / bit 05 -> enable native x87 FPU mode /
#define CR0_WP 0x00010000 / bit 16 -> enable write protect (for CoW) /
#define CR0_AM 0x00040000 / bit 18 -> enable alignment checking /
#define CR0_PG 0x80000000 / bit 31 -> enable paging */
#ifdef TINYC
.data
#else
.section .setup, "a" /* "a" attribute means Allocatable section */
#endif
.align 4
tmp_gdtr:
.word ((3 * 8) - 1)
tmp_gdta:
.long tmp_gdt
.align 4
tmp_gdt:
/* NULL DESCRIPTOR */
.word 0x0000
.word 0x0000
.word 0x0000
.word 0x0000
/* KERNEL CODE /
.word 0xFFFF / segment limit 15-00 /
.word 0x0000 / base address 15-00 /
.byte 0x00 / base address 23-16 /
.byte 0x9A / P=1 DPL=00 S=1 TYPE=1010 (exec/read) /
.byte 0xCF / G=1 DB=1 0=0 AVL=0 SEGLIM=1111 /
.byte GDT_BASE >> 24 / base address 31-24 */
/* KERNEL DATA /
.word 0xFFFF / segment limit 15-00 /
.word 0x0000 / base address 15-00 /
.byte 0x00 / base address 23-16 /
.byte 0x92 / P=1 DPL=00 S=1 TYPE=0010 (read/write) /
.byte 0xCF / G=1 DB=1 0=0 AVL=0 SEGLIM=1111 /
.byte GDT_BASE >> 24 / base address 31-24 */
#ifdef TINYC
.text
#endif
.align 4
multiboot_header: /* multiboot header /
.long MULTIBOOT_HEADER_MAGIC / magic /
.long MULTIBOOT_HEADER_FLAGS / flags /
/ checksum /
.long -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
/ no used /
.long 0 / header_addr /
.long 0 / load_addr /
.long 0 / load_end_addr /
.long 0 / bss_end_addr /
.long 0 / entry_addr /
/ valid only with GRUB2 /
.long 0 / mode_type /
.long 0 / width /
.long 0 / height /
.long 0 / depth */
/*

We use the CX register in order to keep intact the values in AX and BX
registers, since they are holding the Multiboot values 'magic' and 'info'
respectively.
*/

.align 4
.globl _start; _start:
cli
#ifdef TINYC
movl $tmp_gdt, %esi
subl $PAGE_OFFSET, %esi
movl $tmp_gdta, %edi
subl $PAGE_OFFSET, %edi
movl %esi, (%edi)
movl $tmp_gdtr, %esi
subl $PAGE_OFFSET, %esi
lgdt (%esi) /* load GDTR with the temporary GDT /
#else
lgdt tmp_gdtr / load GDTR with the temporary GDT */
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
.globl setup_kernel; setup_kernel:
movl $PAGE_OFFSET + 0x10000, %esp /* default stack address */
pushl $0 /* reset EFLAGS */
popf
pushl %ebx /* save Multiboot info structure /
pushl %eax / save Multiboot magic value */
call setup_tmp_pgdir /* setup a temporary page directory */
movl %eax, %cr3
movl %cr0, %eax
andl $0x00000011, %eax /* disable all, preserve ET & PE (GRUB) /
orl $CR0_PG, %eax / enable PG /
orl $CR0_AM, %eax / enable AM /
orl $CR0_WP, %eax / enable WP /
orl $CR0_NE, %eax / enable NE /
orl $CR0_MP, %eax / enable MP */
movl %eax, %cr0
call bss_init /* initialize BSS segment /
call gdt_init / setup and load the definitive GDT */
call get_last_boot_addr
popl %ecx /* restore Multiboot magic value /
popl %ebx / restore Multiboot info structure */
pushl %eax /* save the last boot address /
pushl %ebx / save Multiboot info structure /
pushl %ecx / save Multiboot magic value */
call start_kernel
/* not reached */
jmp cpu_idle
.section .note.GNU-stack,"",@progbits
/*

64-bit x86 version (x86_64 boot.S adaptation)
Synthesized and elevated for 64-bit architecture using Multiboot2.
Assumes higher-half kernel mapping at 0xffffffff80000000.
Includes checks for multiboot, CPUID, long mode.
Sets up identity paging for initial boot area.

*/
#define ASM_FILE 1
#include <fiwix/segments.h>  /* Adjust for 64-bit if needed */
#include <fiwix/multiboot2.h>
.section .multiboot_header
.align 8
header_start:
.long MULTIBOOT2_HEADER_MAGIC          /* 0xe85250d6 /
.long MULTIBOOT_ARCHITECTURE_I386      / 0 for i386 (32-bit protected mode entry) /
.long header_end - header_start
/ checksum /
.long -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (header_end - header_start))
/ end tag */
.word 0
.word 0
.long 8
header_end:
.section .text
.bits 32
.global _start
_start:
/* Setup stack /
movl $stack_top - 0xffffffff80000000, %esp  / Physical address for initial stack */
call check_multiboot
call check_cpuid
call check_long_mode
call setup_page_tables
call enable_paging
lgdt [gdt64_pointer - 0xffffffff80000000]  /* Physical address */
jmp $GDT_CODE64, $long_mode_start - 0xffffffff80000000  /* Jump to long mode (physical) */
check_multiboot:
cmpl $MULTIBOOT2_BOOTLOADER_MAGIC, %eax
jne .no_multiboot
ret
.no_multiboot:
movb $'0', %al
jmp error
check_cpuid:
pushf
pop %eax
mov %eax, %ecx
xor $1 << 21, %eax
push %eax
popf
pushf
pop %eax
push %ecx
popf
cmp %eax, %ecx
je .no_cpuid
ret
.no_cpuid:
movb $'1', %al
jmp error
check_long_mode:
movl $0x80000000, %eax
cpuid
cmpl $0x80000001, %eax
jb .no_long_mode
movl $0x80000001, %eax
cpuid
test $1 << 29, %edx
jz .no_long_mode
ret
.no_long_mode:
movb $'2', %al
jmp error
setup_page_tables:
/* Identity map for boot: PML4[0] -> PDP[0] -> PD[0] -> PT[0] for 4KB pages, or use huge pages /
movl $pdp_table - 0xffffffff80000000, %eax
orl $0b11, %eax  / present + writable */
movl %eax, pml4_table - 0xffffffff80000000
movl $pd_table - 0xffffffff80000000, %eax
orl $0b11, %eax
movl %eax, pdp_table - 0xffffffff80000000
/* Map kernel area, assume 2MB huge pages for simplicity /
movl $0, %ecx
.map_pd_table:
movl $0x200000, %eax  / 2MB /
mull %ecx
orl $0b10000011, %eax  / present + writable + huge */
movl %eax, pd_table - 0xffffffff80000000 + %ecx * 8
incl %ecx
cmpl $512, %ecx  /* Map 1GB */
jne .map_pd_table
ret
enable_paging:
movl $pml4_table - 0xffffffff80000000, %eax
movl %eax, %cr3
/* Enable PAE */
movl %cr4, %eax
orl $1 << 5, %eax
movl %eax, %cr4
/* Set long mode bit in EFER */
movl $0xC0000080, %ecx
rdmsr
orl $1 << 8, %eax
wrmsr
/* Enable paging */
movl %cr0, %eax
orl $1 << 31, %eax
movl %eax, %cr0
ret
error:
movl $0x4f524f45, 0xb8000
movl $0x4f3a4f52, 0xb8004
movl $0x4f204f20, 0xb8008
movb %al, 0xb800a
hlt
.section .rodata
.align 8
gdt64:
.quad 0  /* null descriptor /
/ 64-bit code segment /
.quad (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)  / code: present, long mode, code, conforming /
/ 64-bit data segment (if needed) /
.quad (1 << 41) | (1 << 43) | (1 << 44) | (1 << 47)  / data: writable, present, data /
gdt64_pointer:
.word gdt64_pointer - gdt64 - 1
.quad gdt64 - 0xffffffff80000000  / Physical address */
.section .bss
.align 4096
pml4_table:
.resb 4096
pdp_table:
.resb 4096
pd_table:
.resb 4096
.align 16
stack_bottom:
.resb 16384  /* 16KB stack */
stack_top:
.bits 64
long_mode_start:
/* Update segments /
movw $0, %ax  / Data segment 0 for flat model */
movw %ax, %ds
movw %ax, %es
movw %ax, %fs
movw %ax, %gs
movw %ax, %ss
/* Setup stack in virtual address */
movq $stack_top, %rsp
/* Relocate to higher half */
addq $0xffffffff80000000, %rsp
/* Preserve multiboot magic (rax) and info (rbx) /
/ Call C start_kernel(magic, info_ptr, last_boot_addr) /
/ Assume get_last_boot_addr in C, called later */
/* For simplicity, pass magic and info, compute last_boot in C /
movq %rbx, %rsi  / info /
movq %rax, %rdi  / magic */
extern start_kernel
call start_kernel
/* Not reached */
hlt
.section .note.GNU-stack,"",@progbits