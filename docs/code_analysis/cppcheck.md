# cppcheck Usage and Output

## Installation

```bash
sudo apt install cppcheck
```



## Command

```bash
cppcheck --enable=warning,style,performance,portability --std=c99 .
```

## Sample Output

```text
drivers/block/ata.c:608:6: style: The scope of the variable 'error' can be reduced. [variableScope]
 int error;
     ^
drivers/block/ata.c:748:27: style: The scope of the variable 'brh' can be reduced. [variableScope]
 struct blk_request *br, *brh;
                          ^
drivers/block/ata.c:247:40: style: Parameter 'drive' can be declared as pointer to const [constParameterPointer]
static int get_piomode(struct ata_drv *drive)
                                       ^
drivers/block/ata.c:265:36: style: Parameter 'drive' can be declared as pointer to const [constParameterPointer]
static int get_dma(struct ata_drv *drive)
                                   ^
drivers/block/ata.c:309:36: style: Parameter 'drive' can be declared as pointer to const [constParameterPointer]
static int get_ata(struct ata_drv *drive)
                                   ^
drivers/block/ata.c:550:96: style: Parameter 'ident' can be declared as pointer to const [constParameterPointer]
static void sector2chs(__off_t offset, int *cyl, int *head, int *sector, struct ata_drv_ident *ident)
                                                                                               ^
drivers/block/ata.c:606:28: style: Parameter 'ide' can be declared as pointer to const [constParameterPointer]
void ata_error(struct ide *ide, int status)

```
