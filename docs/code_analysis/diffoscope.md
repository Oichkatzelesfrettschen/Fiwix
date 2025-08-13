# diffoscope

## Installation
```bash
sudo apt install -y diffoscope
```

## Configuration and Usage
`diffoscope` produces detailed, multi-format comparisons. Here two temporary text files are contrasted:
```bash
echo 'alpha' > /tmp/a.txt
echo 'beta' > /tmp/b.txt
diffoscope /tmp/a.txt /tmp/b.txt | head -n 20
```

## Sample Output
```
--- /tmp/a.txt
+++ /tmp/b.txt
@@ -1 +1 @@
-alpha
+beta
```
