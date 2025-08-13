# gdb

## Installation
```bash
sudo apt install -y gdb
```

## Configuration and Usage
A minimal C program is compiled with debug symbols and inspected with `gdb` in batch mode:
```bash
echo 'int main(){return 0;}' > /tmp/gdb_demo.c
clang -g /tmp/gdb_demo.c -o /tmp/gdb_demo
gdb -q -batch -ex 'info functions' /tmp/gdb_demo | head -n 20
```

## Sample Output
```
All defined functions:

File /tmp/gdb_demo.c:
1:      int main();
```
