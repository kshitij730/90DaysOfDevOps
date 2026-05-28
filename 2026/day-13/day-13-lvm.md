# Day 13 – Linux Volume Management (LVM)

## Objective

Today’s goal was to learn Linux Logical Volume Management (LVM) and understand how storage can be managed dynamically in Linux systems.

Instead of using traditional static partitions, LVM allows flexible storage allocation, resizing, and management without recreating disks or losing data.

This exercise focused on:

* Creating Physical Volumes
* Creating Volume Groups
* Creating Logical Volumes
* Formatting and mounting storage
* Extending storage dynamically

---

# Step 1 – Switch to Root User

## Command Used

```bash
sudo -i
```

## Purpose

* Switch to the root user for administrative privileges required by LVM operations.

## Verification

```bash
whoami
```

## Expected Output

```text
root
```

---

# Step 2 – Install LVM Utilities

## Commands Used

```bash
apt update
apt install lvm2 -y
```

## Purpose

* Install LVM management tools required for creating and managing logical volumes.

## Verification

```bash
lvm version
```

## Observation

* LVM utilities installed successfully.

---

# Step 3 – Create a Virtual Disk

Since no spare physical disk was available, a virtual disk image was created for LVM practice.

## Command Used

```bash
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
```

## Purpose

* Create a 1GB virtual disk image file.

## Breakdown

* `if=/dev/zero` → Input source
* `of=/tmp/disk1.img` → Output file
* `bs=1M` → Block size
* `count=1024` → Number of blocks

## Observation

* A 1GB virtual disk image was created successfully.

---

# Step 4 – Attach Loop Device

## Commands Used

```bash
losetup -fP /tmp/disk1.img
```

```bash
losetup -a
```

## Purpose

* Attach the virtual disk image as a loop device so Linux treats it like a real disk.

## Expected Output Example

```text
/dev/loop0: []: (/tmp/disk1.img)
```

## Observation

* Linux assigned the image file to `/dev/loop0`.

---

# Step 5 – Check Current Storage

## Commands Used

```bash
lsblk
```

```bash
pvs
```

```bash
vgs
```

```bash
lvs
```

```bash
df -h
```

## Purpose

* Inspect disks, partitions, mounted filesystems, and existing LVM structures.

## Observation

* No custom LVM setup existed initially.
* Current storage layout was verified successfully.

---

# Step 6 – Create Physical Volume (PV)

## Commands Used

```bash
pvcreate /dev/loop0
```

```bash
pvs
```

## Purpose

* Initialize the loop device as a Physical Volume.

## Expected Output Example

```text
PV           VG   Fmt  Attr PSize PFree
/dev/loop0        lvm2 --- 1.00g 1.00g
```

## Observation

* `/dev/loop0` was successfully converted into a Physical Volume.

---

# Step 7 – Create Volume Group (VG)

## Commands Used

```bash
vgcreate devops-vg /dev/loop0
```

```bash
vgs
```

## Purpose

* Create a Volume Group named `devops-vg`.

## Expected Output Example

```text
VG         #PV #LV #SN Attr   VSize VFree
devops-vg    1   0   0 wz--n- 1.00g 1.00g
```

## Observation

* Volume Group created successfully.
* Storage from the Physical Volume was pooled together.

---

# Step 8 – Create Logical Volume (LV)

## Commands Used

```bash
lvcreate -L 500M -n app-data devops-vg
```

```bash
lvs
```

## Purpose

* Create a 500MB Logical Volume named `app-data`.

## Expected Output Example

```text
LV       VG         Attr       LSize
app-data devops-vg -wi-a----- 500.00m
```

## Observation

* Logical Volume created successfully.

---

# Step 9 – Format the Logical Volume

## Command Used

```bash
mkfs.ext4 /dev/devops-vg/app-data
```

## Purpose

* Create an EXT4 filesystem on the Logical Volume.

## Observation

* Filesystem formatting completed successfully.

---

# Step 10 – Create Mount Point

## Command Used

```bash
mkdir -p /mnt/app-data
```

## Purpose

* Create a mount point directory for the Logical Volume.

## Observation

* Mount directory created successfully.

---

# Step 11 – Mount the Logical Volume

## Commands Used

```bash
mount /dev/devops-vg/app-data /mnt/app-data
```

```bash
df -h /mnt/app-data
```

## Purpose

* Mount the Logical Volume and verify filesystem usage.

## Expected Output Example

```text
Filesystem                       Size  Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data  477M   24K  442M   1% /mnt/app-data
```

## Observation

* The Logical Volume mounted successfully.
* Filesystem usage appeared correctly.

---

# Step 12 – Extend the Logical Volume

## Command Used

```bash
lvextend -L +200M /dev/devops-vg/app-data
```

## Purpose

* Increase Logical Volume size by 200MB.

## Observation

* Storage allocation increased successfully.

---

# Step 13 – Resize the Filesystem

## Commands Used

```bash
resize2fs /dev/devops-vg/app-data
```

```bash
df -h /mnt/app-data
```

## Purpose

* Resize the filesystem to use the newly allocated storage.

## Expected Output Example

```text
Filesystem                       Size  Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data  677M   25K  642M   1% /mnt/app-data
```

## Observation

* Filesystem resized successfully without data loss.

---

# Screenshots Included

1. Initial storage inspection (`lsblk`, `df -h`)
2. Physical Volume creation (`pvs`)
3. Volume Group creation (`vgs`)
4. Logical Volume creation (`lvs`)
5. Mounted filesystem
6. Extended filesystem after resize

---

# Challenges Faced

## Challenge

No spare physical disk was available for LVM practice.

## Solution

Created a virtual disk using:

```bash
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
```

and attached it using `losetup`.

---

# What I Learned

## 1. LVM Provides Flexible Storage Management

Traditional partitions are static, but LVM allows storage to be resized dynamically.

---

## 2. Understanding PV, VG, and LV is Important

LVM works in layers:

* Physical Volume (PV)
* Volume Group (VG)
* Logical Volume (LV)

Understanding this structure is critical for Linux administration.

---

## 3. Volumes Can Be Extended Without Recreating Partitions

Logical volumes and filesystems can be resized without losing data.

This is extremely useful in production systems.

---

# Key Commands Summary

| Purpose                | Command     |
| ---------------------- | ----------- |
| Check disks            | `lsblk`     |
| Create Physical Volume | `pvcreate`  |
| Create Volume Group    | `vgcreate`  |
| Create Logical Volume  | `lvcreate`  |
| Format filesystem      | `mkfs.ext4` |
| Mount volume           | `mount`     |
| Extend volume          | `lvextend`  |
| Resize filesystem      | `resize2fs` |

---

# Key Takeaways

* LVM allows scalable and flexible storage management.
* Storage can be resized dynamically without downtime.
* Loop devices are useful for safe LVM practice environments.
* Filesystems can be expanded without data loss.
* Understanding storage layers is essential for Linux administration.

---

# Conclusion

Successfully practiced Linux Logical Volume Management by:

* Creating a virtual disk
* Creating a Physical Volume
* Creating a Volume Group
* Creating a Logical Volume
* Formatting and mounting storage
* Extending storage dynamically

This exercise demonstrated how Linux administrators manage scalable and flexible storage in real-world production environments.

Status: ✅ Day 13 Complete
