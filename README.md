# homelab-infra

> 🏠 A fully reproducible homelab built with Infrastructure as Code.

## Stack

| Layer | Tool | What it does |
|-------|------|-------------|
| OS config | Ansible | Ubuntu bootstrap, security hardening, K3s install |
| Cloud | Terraform | Cloudflare DNS records, tunnel, ingress rules |
| GitOps | Argo CD | Deploys and reconciles Kubernetes manifests |
| K8s apps | Kubernetes YAMLs | PostgreSQL, Redis, Prometheus, Grafana, whoami |

## Quick Start

```bash
# 1. Configure environment
cp .env.example .env
# Edit .env with your server details

# 2. Source environment variables
source .env

# 3. Install Ansible collections
ansible-galaxy install -r ansible/requirements.yml

# 4. Run bootstrap
ansible-playbook ansible/playbooks/bootstrap.yml
```

## Layers

The bootstrap playbook runs 6 layers in sequence:

| # | Layer | Roles |
|---|-------|-------|
| 1 | Bootstrap | apt, common-packages, hostname, timezone, locale, ntp, ssh |
| 2 | Security | UFW, fail2ban, unattended upgrades |
| 3 | Kubernetes | K3s single-node cluster |
| 4 | Networking | Cloudflare Tunnel (cloudflared) |
| 5 | GitOps | Argo CD installation |
| 6 | Secrets | Auto-generates DB passwords as K8s secrets |

## Project Layout

```
├── ansible/              # Server config (12 roles)
│   ├── inventory/        # Host definitions, group vars
│   ├── playbooks/        # bootstrap.yml — all layers
│   └── roles/            # apt, ssh, k3s, argocd, cloudflare-tunnel, …
├── terraform/
│   └── cloudflare/       # DNS records, tunnel, ingress rules
├── kubernetes/
│   ├── apps/whoami       # Test app
│   ├── databases/        # PostgreSQL, Redis
│   ├── monitoring/       # Prometheus, Grafana, node-exporter, kube-state-metrics
│   └── argocd/           # Application CRDs (databases, monitoring, whoami)
├── .env.example          # Environment variable template
└── docs/context.md       # Full roadmap and design notes
```

## 🔐 Secrets

**No secrets committed to this repo.** All sensitive values are injected via environment variables at runtime (see [`.env.example`](.env.example)).

Required vars:
- `ANSIBLE_USER`, `ANSIBLE_SSH_PRIVATE_KEY_FILE` — SSH access
- `HOMELAB_SERVER_IP`, `HOMELAB_HOSTNAME` — target server
- `TF_VAR_cloudflare_*` — Cloudflare API token, account ID, zone ID
- `ARGOCD_REPO_SSH_PRIVATE_KEY` — deploy key for Argo CD

## License

[Apache 2.0](LICENSE)
