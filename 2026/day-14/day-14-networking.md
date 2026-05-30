# Day 14 – Networking Fundamentals & Hands-on Checks

## Quick Concepts
- **OSI layers (L1–L7) vs TCP/IP stack:**
  - OSI has 7 layers: Physical, Data Link, Network, Transport, Session, Presentation, Application. TCP/IP has 4: Link, Internet, Transport, Application.
  - OSI is a theoretical model; TCP/IP is practical and widely used in real networks.
- **Where protocols sit:**
  - IP: Internet layer (TCP/IP), Network layer (OSI)
  - TCP/UDP: Transport layer (both models)
  - HTTP/HTTPS: Application layer (both models)
  - DNS: Application layer (both models)
- **Example:**
  - `curl https://example.com` = Application (HTTP) over Transport (TCP) over Internet (IP) over Link (Ethernet/Wi-Fi)

---

## Hands-on Checklist

### 1. Identity
- Command: `hostname -I`
- Output: `192.168.1.10`
- Observation: This is my local IP address assigned by the router.

### 2. Reachability
- Command: `ping google.com`
- Output: `64 bytes from ... time=20ms`
- Observation: Latency is low, no packet loss. Host is reachable.

### 3. Path
- Command: `traceroute google.com`
- Output: Shows 8 hops, no timeouts.
- Observation: All hops respond quickly; no long delays.

### 4. Ports
- Command: `ss -tulpn`
- Output: `LISTEN 0 128 0.0.0.0:22 ... sshd`
- Observation: SSH is listening on port 22.

### 5. Name resolution
- Command: `nslookup google.com`
- Output: `Name: google.com Address: 142.250.182.206`
- Observation: DNS resolves domain to IP correctly.

### 6. HTTP check
- Command: `curl -I https://google.com`
- Output: `HTTP/2 200`
- Observation: HTTP status code 200, site is up.

### 7. Connections snapshot
- Command: `netstat -an | head`
- Output: Shows several ESTABLISHED and LISTEN states.
- Observation: More LISTEN than ESTABLISHED, indicating waiting services.

---

## Mini Task: Port Probe & Interpret
1. Listening port: SSH on 22 (from `ss -tulpn`).
2. Test: `nc -zv localhost 22`
   - Output: `Connection to localhost 22 port [tcp/ssh] succeeded!`
3. Interpretation: Port is reachable. If not, next check would be if the sshd service is running or if firewall is blocking.

---

## Reflection
- **Fastest signal when something is broken:** `ping` gives an instant indication of network issues.
- **Layer to inspect if DNS fails:** Check Application layer (DNS), then Network/Internet layer for connectivity.
- **Layer to inspect if HTTP 500:** Application layer (web server/app logic).
- **Two follow-up checks in a real incident:**
  1. Check service status (e.g., `systemctl status nginx`)
  2. Review firewall rules (`sudo ufw status` or `iptables -L`)

---

## Learn in Public
Practiced `ping`, `traceroute`, `ss`, `curl`, and `netstat`. Noticed that traceroute to google.com had no timeouts and curl returned HTTP 200 instantly.

#90DaysOfDevOps  #DevOpsKaJosh  #TrainWithShubham
