# AGENTS.md — star-dockers

## What this repo is
Docker Compose deployment toolkit for a Spring Cloud microservices system.
**Do not attempt to build or compile code here** — JARs and frontend assets are downloaded from a remote CI server.

## Key commands

```bash
# First-time setup: init directories, download JARs/frontend, swap IPs
bash init.sh

# Start everything (shuts down first, starts middleware, then microservices)
bash startup.sh

# Stop everything
bash shutdown.sh

# Download updated JARs from CI and restart affected containers
cd microsystem && bash sync-and-restart.sh

# Download frontend assets from CI
cd middleware/nginx && bash sync-frontend.sh

# Replace hardcoded IP (192.168.1.108) throughout config files
bash replace_ip.sh
```

## Architecture and startup order

```
middleware/  → microsystem/  → bizservices/
(step 1)      (step 2)        (step 3)
```

**Startup is strict and sequential.** Middleware (especially Nacos) must be healthy before microservices start.
Microservices themselves have health-check dependency chains:
- `c-system (healthy) → c-gateway, c-iot, c-tag`
- `c-iot (healthy) → c-iot-gateway`

## Shell script conventions

- **All scripts are bash, not POSIX sh.** They use `declare -A`, `[[]]`, `${!var[@]}`, and other bashisms. Shebangs may say `#!/bin/bash` or `#!/bin/sh` but bash is the real runtime.
- `startup.sh` and `shutdown.sh` use `set -euo pipefail`.
- The `OLDPWD` variable is used after `cd` to return to original directory (depends on bash's `cd` behavior).
- No linting or testing framework exists in this repo.

## IP address management

- `192.168.1.108` is the template IP used in all config files.
- `replace_ip.sh` searches all non-data-non-log files for this IP and prompts for the real host IP.
- This **must** run after `init.sh` and before first `startup.sh`.
- Key files containing the IP: `microsystem/env.properties`, `bizservices/env.properties`, `microsystem/apps.properties`.

## env.properties — critical for Nacos registration

`SPRING_CLOUD_NACOS_DISCOVERY_IP` in `env.properties` **must** equal the actual host IP. If wrong, services will register with a wrong address in Nacos and be unreachable.

The env files are loaded by docker-compose via `env_file:` (not inline variables).

## Service health checks

All microservices expose `GET /health` returning text containing `OK` or `UP`. The health check command:
```
wget -qO- http://localhost:8080/health | grep -q 'OK\|UP'
```

## Java and JVM

- Base image: `docker.1ms.run/eclipse-temurin:8-jdk`
- Default heap: `-Xms512m -Xmx512m`
- Container memory limit: 768m
- Simple services (bizservices) have no health checks or graceful restart logic.

## Debugging

- `JDWP_PORT=5005` in `env.properties` enables remote JVM debugging.
- Each service maps `5005` to a different host port (15005–15009 in microsystem).
- Arthas is volume-mounted from `toolkits/arthas` into `docker exec -it <container> bash` then `/opt/arthas/as.sh`.

## Logs

- Logs are volume-mounted to `microsystem/logs/<service-name>/` on the host.
- `bin/log-monitor.sh` provides log analysis with time filters and top-error summaries.
- `microsystem/find_error.sh` is a simpler grep wrapper for searching error logs.

## JAR updates (sync-and-restart)

`sync-and-restart.sh` compares **file size** (Content-Length header) between local and remote JARs. If sizes differ, downloads new JAR, optionally verifies SHA256 (if a `.sha256` URL exists), backs up old JAR, and restarts the container.
- `--download-only` flag skips restart (used by `init.sh`).
- JAR remote URLs are defined in `microsystem/apps.properties`.
