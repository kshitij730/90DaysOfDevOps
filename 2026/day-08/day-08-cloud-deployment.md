# Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment

## Cloud Provider

AWS EC2 (Ubuntu 22.04)

## Instance Details

- OS: Ubuntu 22.04 LTS
- Web Server: Nginx
- Container Runtime: Docker
- Public Access: Enabled on Port 80

---

## Commands Used

### Connect via SSH

```bash
ssh -i my-key.pem ubuntu@<public-ip>
```

### Update System

```bash
sudo apt update && sudo apt upgrade -y
```

### Install Docker

```bash
sudo apt install docker.io -y
```

### Verify Docker

```bash
docker --version
sudo systemctl status docker
```

### Install Nginx

```bash
sudo apt install nginx -y
```

### Verify Nginx

```bash
sudo systemctl status nginx
```

### Run Nginx Container

```bash
sudo docker run -d -p 8080:80 nginx
```

### View Logs

```bash
sudo tail -n 50 /var/log/nginx/access.log
```

### Save Logs

```bash
sudo tail -n 50 /var/log/nginx/access.log > ~/nginx-logs.txt
```

---

## Screenshots

1. SSH Connection (`ssh-connection.png`)
2. Nginx Welcome Page (`nginx-webpage.png`)
3. Docker Nginx Container (`docker-nginx.png`)

---

## Challenges Faced

### Challenge 1

Port 80 was not accessible initially.

### Solution

Updated Security Group rules and allowed HTTP traffic on port 80.

---

## What I Learned

- How to launch and access a cloud server using SSH
- How to install and manage Docker
- How to deploy and verify Nginx
- How Security Groups control network access
- How to access and export server logs
- Basic cloud server administration workflow

---

## Conclusion

Successfully deployed an Ubuntu cloud server, installed Docker and Nginx, configured public access, verified deployment through a browser, and extracted Nginx logs for analysis.