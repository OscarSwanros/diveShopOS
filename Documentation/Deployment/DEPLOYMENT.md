# DiveShopOS Deployment Guide

## Infrastructure Overview

| Component | Staging | Production |
|-----------|---------|------------|
| Provider | Vultr | Vultr |
| Server | 1 vCPU / 1GB RAM (~$6/mo) | 2 vCPU / 4GB RAM ($24/mo) |
| OS | Ubuntu 24.04 | Ubuntu 24.04 |
| Database | PostgreSQL 17 (Docker accessory) | PostgreSQL 17 (Docker accessory) |
| DNS/SSL | Cloudflare (free tier) | Cloudflare (free tier) |
| Registry | ghcr.io/swanros/diveshopos | ghcr.io/swanros/diveshopos |
| Domain | staging.vamosabucear.com | vamosabucear.com |

## Architecture

```
[Browser] → [Cloudflare DNS/SSL] → [Vultr Server :80] → [Kamal Proxy] → [Rails App Container]
                                                                      → [PostgreSQL Container]
```

Cloudflare terminates SSL and proxies traffic to the origin server over HTTP on port 80. Rails is configured with `assume_ssl = true` so it generates `https://` URLs correctly. `force_ssl` is NOT enabled to avoid redirect loops with Cloudflare.

## Prerequisites

1. **Vultr account** with SSH key uploaded
2. **Cloudflare account** with `vamosabucear.com` domain added
3. **GitHub PAT** with `write:packages` scope for ghcr.io
4. **Local tools**: Docker, Kamal (`gem install kamal`), SSH

## Server Provisioning

### 1. Create Vultr Instance

1. Go to Vultr dashboard → Deploy New Server
2. Choose: Cloud Compute (Shared CPU)
3. Location: US (closest to target users)
4. OS: Ubuntu 24.04 LTS
5. Plan: See table above for staging vs production sizing
6. Add your SSH key
7. Set hostname: `staging.diveshopos` or `production.diveshopos`
8. Deploy and note the IP address

### 2. Run Server Setup

```bash
ssh root@<IP> 'bash -s' < bin/server-setup
```

This script:
- Installs Docker
- Creates a `deploy` user with Docker group access
- Copies SSH keys from root to deploy
- Hardens SSH (disables root login and password auth)
- Configures UFW firewall (SSH, HTTP, HTTPS only)
- Sets up 2GB swap
- Sets timezone to UTC

### 3. Verify SSH Access

```bash
ssh deploy@<IP> "docker --version"
```

## Cloudflare DNS/SSL Configuration

### DNS Records

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | `@` | `<production-IP>` | Proxied (orange cloud) |
| A | `staging` | `<staging-IP>` | Proxied (orange cloud) |
| A | `www` | `<production-IP>` | Proxied (orange cloud) |

### SSL/TLS Settings

1. Go to SSL/TLS → Overview
2. Set encryption mode to **Flexible**
   - Cloudflare terminates SSL; origin receives HTTP
   - Rails `assume_ssl = true` handles URL generation
3. Edge Certificates → Always Use HTTPS: **On**
4. Edge Certificates → Automatic HTTPS Rewrites: **On**

### Whitelabel Domains

For each dive shop's custom domain:
1. Shop adds a CNAME record pointing to `vamosabucear.com`
2. In Cloudflare, no action needed (the proxy handles it)
3. TenantResolver validates the domain against Organization records

## Environment Variables

Set these in your shell before deploying (e.g., in `~/.zshrc` or a `.env` file sourced before deploy):

| Variable | Description | Example |
|----------|-------------|---------|
| `KAMAL_REGISTRY_PASSWORD` | GitHub PAT with `write:packages` | `ghp_xxxx` |
| `DB_HOST` | PostgreSQL host (Docker network) | `vamosabucear-db` |
| `DB_USER` | PostgreSQL user | `diveshopos` |
| `DB_PASSWORD` | PostgreSQL password | (generate a strong password) |

The `RAILS_MASTER_KEY` is read from `config/master.key` automatically.

## First-Time Deployment

### 1. Update Server IPs

Edit the destination files with your actual Vultr IPs:

```bash
# config/deploy.staging.yml - replace STAGING_IP_HERE
# config/deploy.production.yml - replace PRODUCTION_IP_HERE
```

### 2. Set Environment Variables

```bash
export KAMAL_REGISTRY_PASSWORD="ghp_your_github_pat"
export DB_HOST="vamosabucear-db"
export DB_USER="diveshopos"
export DB_PASSWORD="your_strong_password_here"
```

### 3. Verify Configuration

```bash
bin/kamal config -d staging
bin/kamal config -d production
```

### 4. Run Kamal Setup

```bash
# Staging first
bin/kamal setup -d staging

# Then production
bin/kamal setup -d production
```

This will:
- Push the Docker image to ghcr.io
- Start the PostgreSQL accessory container
- Start the Kamal proxy
- Deploy the Rails app container
- Run `db:prepare` (creates databases and runs migrations)

### 5. Verify

```bash
curl -I https://staging.vamosabucear.com/up
curl -I https://vamosabucear.com/up
```

## Release Process

### Staging Deploy

```bash
bin/deploy staging
```

This runs CI checks then deploys. Any branch can be deployed to staging.

### Production Deploy

```bash
bin/deploy production
```

Production deploys enforce:
- Must be on `main` branch
- Working directory must be clean
- Must be up to date with `origin/main`
- CI checks must pass

### Manual Kamal Commands

```bash
# Deploy without CI checks (emergency)
bin/kamal deploy -d production

# Rollback to previous version
bin/kamal rollback -d production

# View logs
bin/kamal logs -d production

# Rails console
bin/kamal console -d production

# Run a one-off command
bin/kamal app exec -d production "bin/rails db:migrate"
```

## Database Backup & Restore

### Backup

```bash
bin/backup-db production
bin/backup-db staging
```

Backups are saved to `tmp/backups/` with timestamps.

### Restore

```bash
psql -h <host> -U diveshopos -d vamosabucear_production < tmp/backups/vamosabucear_production_20260213_120000.sql
```

### Automated Backups (Server-Side Cron)

SSH into the server and set up a daily backup cron for the deploy user:

```bash
ssh deploy@<production-IP>

# Add to crontab
crontab -e

# Daily backup at 3 AM UTC, keep 14 days
0 3 * * * docker exec vamosabucear-db pg_dump -U diveshopos -d vamosabucear_production | gzip > /home/deploy/backups/db_$(date +\%Y\%m\%d).sql.gz && find /home/deploy/backups -name "db_*.sql.gz" -mtime +14 -delete

# Create backups directory
mkdir -p /home/deploy/backups
```

## Monitoring

### Health Check

Both staging and production expose a `/up` endpoint that returns 200 when the app is healthy.

### UptimeRobot (Free Tier)

1. Sign up at [uptimerobot.com](https://uptimerobot.com)
2. Add monitors:
   - **Production**: `https://vamosabucear.com/up` (check every 5 min)
   - **Staging**: `https://staging.vamosabucear.com/up` (check every 5 min)
3. Configure email alerts

### Manual Checks

```bash
# App status
bin/kamal details -d production

# Container logs
bin/kamal logs -d production

# Database accessory logs
bin/kamal accessory logs db -d production
```

## Troubleshooting

### App won't start

```bash
# Check logs for errors
bin/kamal logs -d production

# Check if containers are running
bin/kamal details -d production

# SSH into server directly
ssh deploy@<IP> "docker ps -a"
```

### Database connection errors

```bash
# Verify the db accessory is running
bin/kamal accessory details db -d production

# Test connection from app container
bin/kamal app exec -d production "bin/rails dbconsole --include-password"
```

### SSL/redirect issues

- Verify Cloudflare SSL mode is **Flexible** (not Full or Strict)
- Verify `config.assume_ssl = true` is set
- Verify `config.force_ssl` is NOT enabled
- Check that Cloudflare proxy is enabled (orange cloud) on DNS records

### Deployment fails during image push

- Verify `KAMAL_REGISTRY_PASSWORD` is set and the GitHub PAT has `write:packages` scope
- Try logging in manually: `echo $KAMAL_REGISTRY_PASSWORD | docker login ghcr.io -u swanros --password-stdin`

### "Host not allowed" errors

- Verify `config.hosts.clear` is set in the environment file
- TenantResolver handles domain validation; Rails host authorization must be disabled for whitelabel
