# cscope

## Installation
```bash
sudo apt install -y cscope
```

## Configuration and Usage
The kernel sources are indexed to enable symbol lookups. A file list is generated from tracked C sources and fed to `cscope` to build the cross-reference database:
```bash
git ls-files '*.c' > cscope.files
cscope -bq -i cscope.files
```
Once indexed, symbol definitions are queried non-interactively. For example, locating the `start_kernel` entry point:
```bash
cscope -L -0 start_kernel
```

## Sample Output
```
kernel/main.c start_kernel 65 void start_kernel(unsigned int magic, unsigned int info, unsigned int last_boot_addr)
```
