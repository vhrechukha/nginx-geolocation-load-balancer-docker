# NGINX GeoIP Load Balancer Project

## Project Overview

This project sets up an NGINX load balancer that routes incoming traffic based on the geographical location of the client's IP address. The configuration includes one server for the UK, two servers for the US, and one server for the rest of the world. In the event of a server failure, all traffic is redirected to a backup server. The load balancer also performs health checks every 5 seconds to ensure that all servers are operational.

The project utilizes a GeoIP database (GeoLite2-Country.mmdb) to determine the client's location.


## Prerequisites

- **Docker**
- **Docker Compose**
- **ngrok**
- **Touch VPN**: Install the Touch VPN Chrome extension for testing geolocation.

## Steps to Run

```
docker-compose up -d
```

## How to Test the Load Balancer

1. **Expose the Local Server with ngrok**:
   Use ngrok to create a tunnel to your local NGINX server.

   ```bash
   ngrok http 80
   ```
   Note the public URL provided by ngrok.

2. Connect to Different Regions Using Touch VPN: Use the Touch VPN Chrome extension to connect to various regions (e.g., UK, US).

3. Access the ngrok URL: Open the ngrok URL in your browser while connected to different VPN regions.

4. Verify Routing in NGINX Logs: Monitor the NGINX logs to see which upstream server handled each request.
   ```bash
    docker logs -f nginx_load_balancer
    ```

5. Simulate Server Failure: Stop one of the primary servers to test the failover mechanism.
    ```bash
    docker stop uk_server
    ```

6. Access the ngrok URL again to verify traffic is routed to the backup server. 

### Expected Results
- Traffic should be routed based on geographical location.
- Failover functionality should redirect traffic to the backup server during a primary server outage.
- Logs should accurately reflect the routing decisions made by NGINX.

```
2024-09-22 21:33:33 185.239.174.66 - - [22/Sep/2024:19:33:33 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36" upstream: 172.22.0.3:80 upstream_server_name: UK Server client_ip: 185.239.174.66 forwarded_for: 185.239.174.66 geoip_source: GB host: x.ngrok-free.app
2024-09-22 21:34:04 84.245.120.110 - - [22/Sep/2024:19:34:04 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36" upstream: 172.22.0.7:80 upstream_server_name: Rest Server client_ip: 84.245.120.110 forwarded_for: 84.245.120.110 geoip_source: SK host: x.ngrok-free.app
```
