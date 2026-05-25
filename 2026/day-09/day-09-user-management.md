# Day 09 Challenge

## Users & Groups Created

### Users
- tokyo
- berlin
- professor
- nairobi

### Groups
- developers
- admins
- project-team

---

## Task 1: Create Users

### Commands Used

```bash
sudo adduser -m tokyo


sudo adduser -m berlin

sudo adduser -m professor

```

### Verification

Check user entries:

```bash
grep -E "tokyo|berlin|professor" /etc/passwd
```

Check home directories:

```bash
ls -l /home
```

### Screenshot

> (`create-user.png`)
---

## Task 2: Create Groups

### Commands Used

```bash
sudo groupadd developers
sudo groupadd admins
```

### Verification

```bash
grep -E "developers|admins" /etc/group
```

### Screenshot

> (`create-group.png`)

---

## Task 3: Assign Users to Groups

### Group Assignments

| User | Groups |
|------|--------|
| tokyo | developers |
| berlin | developers, admins |
| professor | admins |

### Commands Used

```bash
sudo gpasswd -a developers tokyo

sudo gpasswd -a developers berlin
sudo gpasswd -a admins berlin

sudo gpasswd -a admins professor
```

### Verification

```bash
groups tokyo
groups berlin
groups professor
```

### Screenshot

> (`group-check.png`)

---

## Task 4: Shared Directory

### Create Directory

```bash
sudo mkdir -p /opt/dev-project
```

### Set Group Ownership

```bash
sudo chgrp developers /opt/dev-project
```

### Set Permissions

```bash
sudo chmod 775 /opt/dev-project
```

### Verify Permissions

```bash
ls -ld /opt/dev-project
```

Expected permission:

```text
drwxrwxr-x
```

### Test Access

Create files as different users:

```bash
sudo -u tokyo touch /opt/dev-project/tokyo.txt

sudo -u berlin touch /opt/dev-project/berlin.txt
```

Verify:

```bash
ls -l /opt/dev-project
```

### Screenshot

> (`shared-directory.png`)

---

## Task 5: Team Workspace

### Create User

```bash
sudo useradd -m nairobi
sudo passwd nairobi
```

### Create Group

```bash
sudo groupadd project-team
```

### Add Users to Group

```bash
sudo usermod -aG project-team nairobi
sudo usermod -aG project-team tokyo
```

### Create Workspace Directory

```bash
sudo mkdir -p /opt/team-workspace
```

### Configure Ownership and Permissions

```bash
sudo chgrp project-team /opt/team-workspace

sudo chmod 775 /opt/team-workspace
```

### Verification

```bash
ls -ld /opt/team-workspace
```

### Test File Creation

```bash
sudo -u nairobi touch /opt/team-workspace/nairobi.txt
```

Verify:

```bash
ls -l /opt/team-workspace
```

### Screenshot

> (`create-team-workspace.png`)

---

## Group Assignments

| User | Group Membership |
|------|------------------|
| tokyo | developers, project-team |
| berlin | developers, admins |
| professor | admins |
| nairobi | project-team |

Verification:

```bash
groups tokyo
groups berlin
groups professor
groups nairobi
```

---

## Directories Created

| Directory | Group Owner | Permissions |
|-----------|------------|------------|
| /opt/dev-project | developers | 775 |
| /opt/team-workspace | project-team | 775 |

Verification:

```bash
ls -ld /opt/dev-project
ls -ld /opt/team-workspace
```

---

## Commands Used

```bash
useradd
passwd
groupadd
usermod
groups
id
mkdir
chgrp
chmod
touch
ls
grep
sudo
```

---

## What I Learned

1. Linux stores user information in `/etc/passwd` and group information in `/etc/group`.
2. Users can belong to multiple groups using the `usermod -aG` command.
3. Group ownership and permissions help multiple users collaborate securely.
4. Permission mode `775` allows the owner and group members to read, write, and execute, while others can only read and execute.
5. The `sudo -u username` command is useful for testing permissions as another user without switching accounts.

---

## Troubleshooting

### Permission Denied

```bash
sudo chmod 775 /path/to/directory
sudo chgrp groupname /path/to/directory
```

### Check User Groups

```bash
groups username
```

### Check Permissions

```bash
ls -ld /path/to/directory
```

### Check User Details

```bash
id username
```

---

## Conclusion

Successfully completed Linux User & Group Management tasks:

- Created users and passwords
- Created groups
- Assigned users to groups
- Configured shared directories with group permissions
- Tested collaborative access using different user accounts

#90DaysOfDevOps  
#DevOpsKaJosh  
#TrainWithShubham