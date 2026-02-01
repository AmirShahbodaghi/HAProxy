What is Keepalived?

Keepalived is a Linux service used to achieve high availability (HA). Its main job is to make sure a critical service or IP address is always available, even if one server goes down.
If one server fails, Keepalived automatically shifts traffic to another server.

Keepalived works by managing a Virtual IP (VIP) that floats between multiple servers.
One server is ACTIVE (Master)
One or more servers are STANDBY (Backup)
Clients always connect to the VIP, not to a specific server
If the master fails, a backup takes over the VIP

VRRP (Virtual Router Redundancy Protocol)
This is the heart of Keepalived.
Servers exchange heartbeat messages
The server with the highest priority becomes MASTER
If heartbeats stop → failover happens

Virtual IP (VIP)
A floating IP address
Always assigned to one server at a time
Moves automatically during failover

Example:
VIP: 192.168.1.100
Master: 192.168.1.10
Backup: 192.168.1.11
Clients only know 192.168.1.100.

Health Checks
Keepalived can monitor:
A process (e.g., nginx, haproxy)
A port
A script (custom logic)
If the check fails → that node loses priority → backup takes over.

Typical Use Cases
Keepalived is commonly used with:
HAProxy / NGINX → load balancer HA
Kubernetes API Server HA
Database primary/secondary setups
Any critical service needing zero (or minimal) downtime

---------------------------------------------------------------------------------------------

Architecture Overview
Clients
   |
Virtual IP (VIP) 192.168.1.100
   |
-------------------------------
| Server 1 (MASTER)           |
|  HAProxy + Keepalived       |
-------------------------------
| Server 2 (BACKUP)           |
|  HAProxy + Keepalived       |
-------------------------------

Keepalived manages the Virtual IP (VIP)
HAProxy listens on the VIP
Only one server owns the VIP at a time
Docker runs in host network mode (required for VRRP)

مراحل اجرای Docker
روی هر HAProxy سرور، فایل‌های haproxy.cfg و keepalived.conf را قرار دهید.

سپس اجرا کنید:
sudo docker-compose up -d

بررسی اینکه VIP بالا آمده است:
ip addr show | grep 192.168.100.10

تست اتصال به Kubernetes API:
curl -k https://192.168.100.10:6443/version











