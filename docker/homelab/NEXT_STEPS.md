# Homelab Next Steps - Tomorrow's Plan

## Priority Tasks (1,3,4,5,6)

### 1. Infrastructure Health Check ⚠️ HIGH PRIORITY
**Current Status:** Mixed - some services running, issues found
- **Keycloak**: ✅ Running (both app + DB healthy)
- **Traefik**: ✅ Running but missing Cloudflare env vars
- **Shared-infra**: ❌ YAML error - duplicate `volumes:` sections in docker-compose.yml (lines 8 & 52)

**Action Items:**
- Fix shared-infra YAML syntax error
- Set up Cloudflare environment variables for Traefik
- Test PostgreSQL and Redis connectivity
- Verify Traefik routing and SSL

### 3. Monitoring Stack Setup
**Options to consider:**
- **Simple**: Docker health checks + basic status dashboard
- **Advanced**: Prometheus + Grafana stack
- **Hybrid**: Uptime Kuma for simple monitoring

**Implementation approach:**
- Start with container health monitoring
- Add service-specific health endpoints
- Consider adding to existing Traefik setup for easy access

### 4. Backup Strategy ⚠️ CRITICAL
**Key areas:**
- PostgreSQL databases (shared + Keycloak)
- Application configurations
- SSL certificates (Traefik ACME)
- Docker volumes

**Approach:**
- Automated pg_dump for PostgreSQL
- Volume snapshots or bind mounts to backup location
- Consider backup rotation strategy
- Test restore procedures

### 5. Media Services
**Based on existing mounts structure:**
- Mounts already configured for Plex, downloads, media
- TrueNAS and Synology storage available

**Services to add:**
- Plex Media Server
- *arr stack (Sonarr, Radarr, etc.)
- Download client (qBittorrent/Transmission)
- Media management tools

### 6. SSL Certificate Automation
**Current setup:**
- Traefik v3.0 with ACME support
- Missing Cloudflare API tokens

**Tasks:**
- Configure Cloudflare DNS challenge
- Set up certificate storage and renewal
- Test SSL automation
- Monitor certificate expiration

## Environment Issues to Address
- Cloudflare API credentials missing in Traefik setup
- 1Password secret injection for Cloudflare tokens
- Verify all environment file symlinks working

### 9. VPN Server Setup
**Options:**
- **WireGuard**: Modern, fast, simple config (recommended)
- **OpenVPN**: More complex but widely supported
- **Tailscale**: Mesh VPN alternative (easier setup)

**Integration considerations:**
- Route through Traefik for web management
- Split tunneling for Steam Deck (games vs homelab)
- DNS routing to homelab services
- Port forwarding and firewall rules

**Use cases:**
- Remote access to homelab services
- Secure gaming from Steam Deck anywhere
- Access to internal-only services

### 10. Emulator Service for Steam Deck
**Emulation stack options:**
- **EmulationStation + RetroArch**: Classic combo with web interface
- **Batocera**: Complete emulation OS (can run in container)
- **RetroPie web interface**: Lightweight management
- **Steam ROM Manager**: Direct Steam integration

**Architecture:**
- Containerized emulation service
- Web-based ROM management interface  
- Game streaming via Steam Remote Play or Moonlight
- Save state sync across devices

**Integration points:**
- Storage: Mount existing media/games directories
- Streaming: Dedicated gaming network/VLAN
- Authentication: Keycloak SSO for management interface
- Backup: Save states and configurations

**Steam Deck specific:**
- Game Mode compatibility
- Controller configuration management
- Performance profiles per emulator/system

### 11. Nextcloud Deployment
**File sync and collaboration platform**

**Core features:**
- File sync across devices (desktop, mobile, web)
- Document collaboration (OnlyOffice/Collabora integration)
- Calendar and contacts sync
- Talk (chat/video calling)
- Photo backup from mobile devices

**Integration points:**
- **Database**: Use shared PostgreSQL instance
- **Authentication**: Keycloak OIDC/SAML integration
- **Storage**: Mount to TrueNAS/Synology volumes
- **Reverse proxy**: Traefik with SSL termination
- **Backup**: Include in PostgreSQL backup strategy

**Considerations:**
- High storage requirements - use dedicated volume mounts
- Redis caching for performance (shared Redis instance)
- Regular maintenance (occ commands, app updates)

### 12. Immich Photo Management
**Google Photos alternative with AI features**

**Key features:**
- Automatic photo/video backup from mobile
- Face recognition and object detection
- Timeline view with smart search
- Duplicate detection and management
- Raw photo support
- Shared albums and links

**Technical requirements:**
- **Database**: PostgreSQL (can share with other services)
- **Storage**: Large capacity for photos/videos
- **ML/AI**: Machine learning models for recognition
- **Mobile apps**: iOS/Android backup clients

**Integration strategy:**
- Use shared PostgreSQL instance with dedicated database
- Mount photo storage to high-capacity volumes
- Traefik routing with SSL
- Consider GPU acceleration for ML features
- Backup strategy for irreplaceable photos

**Architecture considerations:**
- Separate microservices (server, ML, web)
- Redis for job queuing (shared instance)
- Dedicated network for ML processing
- Storage tiering (SSD for thumbnails, HDD for originals)

### 13. Home Assistant Deployment
**Smart home automation and IoT management platform**

**Core capabilities:**
- Device discovery and integration (Zigbee, Z-Wave, WiFi)
- Automation rules and scenes
- Voice assistant integration (Alexa, Google, local voice)
- Energy monitoring and climate control
- Security system integration
- Mobile app with remote access

**Integration architecture:**
- **Database**: PostgreSQL for long-term data (optional - can use SQLite)
- **Authentication**: Keycloak OIDC integration for unified login
- **Reverse proxy**: Traefik with SSL for remote access
- **Network**: Dedicated IoT VLAN for security isolation
- **Storage**: Configuration backup and snapshot management

**Hardware considerations:**
- **USB devices**: Zigbee/Z-Wave dongles (USB passthrough)
- **Network isolation**: Separate VLAN for IoT devices
- **Backup power**: UPS integration for power monitoring
- **Local processing**: Edge AI for voice/image recognition

**Advanced integrations:**
- **Monitoring**: Expose metrics to Prometheus/Grafana
- **Notifications**: Integration with existing services
- **VPN access**: Secure remote control via WireGuard
- **Media control**: Integration with Plex and other services
- **Photo automation**: Trigger events based on Immich photos

**Security considerations:**
- Firewall rules for IoT device isolation
- Regular security updates and backups
- Local voice processing (no cloud dependencies)
- Network segmentation for smart devices

**Deployment strategy:**
- Start with basic automation (lights, climate)
- Add security system integration
- Implement energy monitoring
- Expand to advanced automations and AI features

## Hardware Architecture Strategy

**Current Main Server:**
- 32GB RAM, 4 CPU cores, 98GB local + network storage
- Ideal for: Database services, Traefik, Keycloak, Nextcloud

**Potential Distributed Services:**

**Raspberry Pi 4/5 Candidates:**
- **Home Assistant**: Perfect fit, low power, handles IoT well
- **VPN Server**: WireGuard runs great on Pi
- **Monitoring**: Lightweight Prometheus node exporter
- **Simple media services**: Basic *arr services

**Mini PC Candidates (Intel N100/AMD):**
- **Immich ML processing**: Needs decent CPU for photo AI
- **Emulation server**: RetroArch + game streaming
- **Plex transcoding**: Hardware acceleration support
- **Backup coordinator**: Offload backup processing

**Benefits of Distribution:**
- Reduce main server CPU load
- Power efficiency (Pi for always-on services)
- Service isolation and redundancy
- Cost-effective scaling
- Specialized hardware (Pi for IoT, Mini PC for GPU tasks)

**Network Considerations:**
- Shared storage access via NFS/SMB
- Inter-service communication over network
- Centralized reverse proxy (Traefik on main server)
- Unified monitoring across nodes

## Centralized Management Strategy

**Option 1: Git-Based Infrastructure as Code**
```
homelab/
├── docker-compose/ (current structure)
├── ansible/ 
│   ├── playbooks/
│   ├── inventory/
│   └── roles/
└── scripts/
    ├── deploy-all.sh
    └── update-services.sh
```

**Option 2: Docker Swarm Mode**
- Convert compose files to swarm stacks
- Central orchestration from main server
- `docker stack deploy` from single location
- Built-in service discovery and load balancing

**Option 3: Kubernetes (K3s)**
- Lightweight Kubernetes across all nodes
- Helm charts for service deployment
- GitOps with ArgoCD or Flux
- Most scalable but higher complexity

**Recommended: Git + Ansible Approach**

**Benefits:**
- Keep existing Docker Compose structure
- Version control for all configurations
- Automated deployment across nodes
- Secure SSH-based management
- Easy rollbacks and updates

**Implementation:**
- Ansible inventory defines which services run where
- Playbooks handle node-specific configurations
- Git hooks trigger deployments
- 1Password integration for secrets across nodes
- Centralized logging and monitoring collection

**Management Workflow:**
1. Edit compose files locally
2. Commit to git repository
3. Run ansible playbook
4. Services deploy to appropriate nodes
5. Monitor via centralized dashboard

## Session Notes
- YAML syntax error in shared-infra blocking database startup
- Keycloak running independently with own DB
- Traefik proxy operational but needs Cloudflare integration
- VPN + emulation services added to roadmap
- Hardware distribution strategy planned for resource optimization
- Good foundation in place, just needs debugging and completion