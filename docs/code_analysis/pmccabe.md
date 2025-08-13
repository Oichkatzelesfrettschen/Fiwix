# pmccabe Usage and Output

## Installation

```bash
sudo apt install pmccabe
```



## Command

```bash
pmccabe $(git ls-files "*.c")
```

## Sample Output

```text
5	5	17	118	26	drivers/block/ata.c(118): ata_identify_device
18	18	41	145	73	drivers/block/ata.c(145): identify_drive
6	6	14	219	27	drivers/block/ata.c(219): get_device_size
4	4	8	247	17	drivers/block/ata.c(247): get_piomode
4	4	8	265	17	drivers/block/ata.c(265): get_dma
4	4	9	309	18	drivers/block/ata.c(309): get_ata
18	18	83	328	144	drivers/block/ata.c(328): show_capabilities
11	13	42	473	76	drivers/block/ata.c(473): ata_softreset
1	1	5	550	9	drivers/block/ata.c(550): sector2chs
2	2	6	560	12	drivers/block/ata.c(560): irq_ide0
2	2	6	573	12	drivers/block/ata.c(573): irq_ide1
1	1	5	586	9	drivers/block/ata.c(586): ide0_timer
1	1	5	596	9	drivers/block/ata.c(596): ide1_timer
13	13	27	606	43	drivers/block/ata.c(606): ata_error
2	2	5	650	8	drivers/block/ata.c(650): ata_delay
2	2	5	659	9	drivers/block/ata.c(659): ata_wait400ns
3	3	11	669	16	drivers/block/ata.c(669): ata_wait_nobusy
5	5	14	686	22	drivers/block/ata.c(686): ata_wait_state
4	4	19	709	28	drivers/block/ata.c(709): ata_io
1	1	4	738	7	drivers/block/ata.c(738): ata_set_timeout

```
