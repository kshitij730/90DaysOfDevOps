# Day 06 – Linux Fundamentals: Read and Write Text Files

## File Creation

### Command 1

```bash
touch notes.txt
```

Purpose:
- Created an empty file named `notes.txt`.

---

## Writing Data

### Command 2

```bash
echo "Learning Linux file operations" > notes.txt
```

Purpose:
- Added the first line to the file using output redirection (`>`).

### Command 3

```bash
echo "Using redirection operators" >> notes.txt
```

Purpose:
- Appended a new line using (`>>`).

### Command 4

```bash
echo "Practicing basic DevOps skills" | tee -a notes.txt
```

Output:

```
Practicing basic devops skills
```

Purpose:
- Displayed text on screen and appended it to the file at the same time.

---

## Reading Data

### Command 5

```bash
cat notes.txt
```

Output:

```
Learning Linux file operations
Using redirection operators
Practicing basic devops skills
Reading files with cat command
Using head to view top lines
Using tail to view last lines
Text files are important on devops
Practice builds confidence
```

Purpose:
- Displayed the complete contents of the file.

### Command 6

```bash
head -n 2 notes.txt
```

Output:

```
Learning Linux file operations
Using redirection operators
```

Purpose:
- Displayed the first two lines of the file.

### Command 7

```bash
tail -n 2 notes.txt
```

Output:

```
Text files are important on devops
Practice builds confidence
```

Purpose:
- Displayed the last two lines of the file.

---

## What I Learned

- How to create a file using `touch`
- How to write text using `>`
- How to append text using `>>`
- How to write and display text using `tee`
- How to read files using `cat`
- How to inspect the beginning and end of a file using `head` and `tail`