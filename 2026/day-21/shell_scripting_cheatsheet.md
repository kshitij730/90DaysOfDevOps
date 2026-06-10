# Shell Scripting Cheat Sheet 🚀

A quick reference guide for Linux, Shell Scripting, Automation, and DevOps Engineers.

---

# Quick Reference Table

| Topic        | Syntax              | Example                |
| ------------ | ------------------- | ---------------------- |
| Variable     | `VAR="value"`       | `NAME="DevOps"`        |
| Argument     | `$1` `$2`           | `./script.sh file.txt` |
| If Condition | `if [ condition ]`  | `if [ -f file ]`       |
| For Loop     | `for i in list`     | `for i in 1 2 3`       |
| While Loop   | `while condition`   | `while true`           |
| Function     | `name() {}`         | `greet() {}`           |
| Grep         | `grep pattern file` | `grep ERROR app.log`   |
| Awk          | `awk '{print $1}'`  | `awk -F: '{print $1}'` |
| Sed          | `sed 's/a/b/g'`     | `sed -i 's/foo/bar/g'` |
| Exit Code    | `$?`                | `echo $?`              |

---

# 1. Basics

## Shebang

```bash
#!/bin/bash
```

Defines the interpreter that executes the script.

---

## Run a Script

```bash
chmod +x script.sh
./script.sh

# OR

bash script.sh
```

---

## Comments

```bash
# Single line comment

echo "Hello" # Inline comment
```

---

## Variables

```bash
NAME="DevOps"

echo $NAME
echo "$NAME"
echo '$NAME'
```

Output:

```text
DevOps
DevOps
$NAME
```

---

## User Input

```bash
read -p "Enter Name: " NAME

echo "Hello $NAME"
```

---

## Command-Line Arguments

```bash
$0  # Script name
$1  # First argument
$2  # Second argument
$#  # Total arguments
$@  # All arguments
$?  # Exit status
```

Example:

```bash
./script.sh devops aws
```

---

# 2. Operators & Conditionals

## String Operators

```bash
[ "$A" = "$B" ]

[ "$A" != "$B" ]

[ -z "$VAR" ]

[ -n "$VAR" ]
```

---

## Integer Operators

```bash
-eq Equal

-ne Not Equal

-lt Less Than

-gt Greater Than

-le Less Than Equal

-ge Greater Than Equal
```

Example:

```bash
if [ "$AGE" -ge 18 ]
then
 echo "Adult"
fi
```

---

## File Test Operators

```bash
-f file.txt

-d directory

-e path

-r file

-w file

-x file

-s file
```

---

## If Else

```bash
if [ condition ]
then
    command
elif [ condition ]
then
    command
else
    command
fi
```

---

## Logical Operators

```bash
&&

||

!
```

Example:

```bash
[ -f file.txt ] && echo "Exists"
```

---

## Case Statement

```bash
case $VAR in

start)
    echo "Starting"
    ;;

stop)
    echo "Stopping"
    ;;

*)
    echo "Invalid"
    ;;

esac
```

---

# 3. Loops

## For Loop

```bash
for fruit in apple banana mango
do
 echo $fruit
done
```

---

## C Style For Loop

```bash
for ((i=1;i<=5;i++))
do
 echo $i
done
```

---

## While Loop

```bash
COUNT=1

while [ $COUNT -le 5 ]
do
 echo $COUNT
 ((COUNT++))
done
```

---

## Until Loop

```bash
COUNT=1

until [ $COUNT -gt 5 ]
do
 echo $COUNT
 ((COUNT++))
done
```

---

## Break

```bash
break
```

---

## Continue

```bash
continue
```

---

## Loop Through Files

```bash
for file in *.log
do
 echo $file
done
```

---

## Loop Through Command Output

```bash
cat users.txt | while read line
do
 echo $line
done
```

---

# 4. Functions

## Create Function

```bash
greet() {
 echo "Hello"
}
```

---

## Call Function

```bash
greet
```

---

## Function Arguments

```bash
greet() {
 echo "Hello $1"
}

greet Kshitij
```

---

## Return vs Echo

```bash
return 0
```

Used for exit status.

```bash
echo "Data"
```

Used for output.

---

## Local Variables

```bash
myfunc() {

 local NAME="DevOps"

}
```

---

# 5. Text Processing Commands

## Grep

```bash
grep ERROR app.log

grep -i error app.log

grep -r error .

grep -c ERROR app.log

grep -n ERROR app.log

grep -v INFO app.log

grep -E "ERROR|FAILED" app.log
```

---

## AWK

Print First Column

```bash
awk '{print $1}' file.txt
```

Field Separator

```bash
awk -F: '{print $1}' /etc/passwd
```

BEGIN END

```bash
awk '
BEGIN {print "Start"}
{print $1}
END {print "End"}
' file.txt
```

---

## Sed

Replace

```bash
sed 's/foo/bar/g' file.txt
```

Delete Line

```bash
sed '3d' file.txt
```

In-place Edit

```bash
sed -i 's/foo/bar/g' file.txt
```

---

## Cut

```bash
cut -d: -f1 /etc/passwd
```

---

## Sort

```bash
sort file.txt

sort -n numbers.txt

sort -r file.txt

sort -u file.txt
```

---

## Uniq

```bash
uniq file.txt

uniq -c file.txt
```

---

## Tr

Uppercase

```bash
tr 'a-z' 'A-Z'
```

Delete Character

```bash
tr -d ','
```

---

## WC

```bash
wc -l file.txt

wc -w file.txt

wc -c file.txt
```

---

## Head & Tail

```bash
head -5 file.txt

tail -5 file.txt

tail -f app.log
```

---

# 6. Useful One-Liners

## Delete Files Older Than 30 Days

```bash
find /backup -mtime +30 -delete
```

---

## Count Log Lines

```bash
wc -l *.log
```

---

## Replace String In Multiple Files

```bash
sed -i 's/old/new/g' *.txt
```

---

## Check Service Status

```bash
systemctl is-active nginx
```

---

## Real-Time Error Monitoring

```bash
tail -f app.log | grep ERROR
```

---

## Top 10 Memory Processes

```bash
ps aux --sort=-%mem | head
```

---

## Disk Usage Alert

```bash
df -h | awk '$5+0 > 80'
```

---

# 7. Error Handling & Debugging

## Exit Code

```bash
echo $?
```

---

## Success

```bash
exit 0
```

---

## Failure

```bash
exit 1
```

---

## Exit On Error

```bash
set -e
```

---

## Undefined Variable Error

```bash
set -u
```

---

## Pipe Failure Detection

```bash
set -o pipefail
```

---

## Debug Mode

```bash
set -x
```

---

## Strict Mode

```bash
set -euo pipefail
```

Production Best Practice.

---

## Trap

```bash
cleanup() {

 echo "Cleaning Up"

}

trap cleanup EXIT
```

---

# Most Important DevOps Commands

```bash
grep
awk
sed
cut
sort
uniq
find
tar
gzip
cron
systemctl
journalctl
ps
top
df
du
```

---

# Golden Rule

> Don't repeat manual work.
>
> If you do the same task twice, automate it.

`#Linux` `#ShellScripting` `#DevOps` `#Automation` `#TrainWithShubham` `#90DaysOfDevOps` `#DevOpsKaJosh` 
