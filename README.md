# homelab-infra

> 🏠 A fully reproducible homelab built with Infrastructure as Code.

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

## Architecture

| Layer | Tool | Responsibility |
|-------|------|---------------|
| Configuration | Ansible | OS setup, packages, Docker, K3s, security hardening |
| Infrastructure | Terraform *(planned)* | Cloud resources (Cloudflare DNS, Hetzner VMs, etc.) |
| GitOps | Argo CD *(planned)* | Kubernetes application deployment and reconciliation |

## Current Status

**Layer 1 — Bootstrap** is complete. The Ansible playbook configures:
- ✅ apt updates & upgrades
- ✅ Common packages (git, curl, wget, unzip, jq, htop, vim, net-tools)
- ✅ Hostname, timezone, locale, NTP
- ✅ SSH server settings
- ✅ apt mirror selection

Additional layers (security, Docker, K3s, Cloudflare Tunnel, Argo CD) will be built in future iterations.

## Quick Start

```bash
# 1. Configure environment
cp .env.example .env
# Edit .env with your server details

# 2. Source environment variables (required every new terminal session)
source .env

# 3. Install Ansible collections (one-time)
cd ansible
ansible-galaxy install -r requirements.yml

# 4. If your user needs a sudo password:
ansible-playbook playbooks/bootstrap.yml --ask-become-pass

# OR if you have passwordless sudo configured:
ansible-playbook playbooks/bootstrap.yml
```

## Project Layout

```
├── ansible/           # Server configuration (active — Layer 1 done)
│   ├── inventory/     # Host definitions and group variables
│   ├── playbooks/     # Playbook entrypoints
│   ├── roles/         # Reusable roles (apt, ssh, ntp, etc.)
│   ├── ansible.cfg    # Ansible configuration
│   └── requirements.yml  # Collection dependencies
├── docs/              # Roadmap and design documentation
│   └── context.md     # Full project roadmap and architecture
├── .env.example       # Environment variable template
├── .gitignore         # Git ignore rules
├── opencode.json      # OpenCode agent configuration
├── LICENSE            # Apache 2.0
└── README.md          # This file
```

## 🔐 Secrets Management

**No secrets are committed to this repository.**

Sensitive values are injected through:
1. **Environment variables** — for local development (see [`.env.example`](.env.example))
2. **GitHub Secrets** — for CI/CD workflows (future)

### Required Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ANSIBLE_USER` | SSH user for Ansible | `ubuntu` |
| `ANSIBLE_SSH_PRIVATE_KEY_FILE` | Path to SSH private key | `~/.ssh/id_ed25519` |
| `HOMELAB_SERVER_IP` | Target server IP address | `192.168.1.100` |
| `HOMELAB_HOSTNAME` | System hostname to set on the server | `ubuntu-server` |
| `APT_MIRROR` | APT package mirror URL | `http://archive.ubuntu.com/ubuntu` |

> ⚠️ `.env` files must use `export KEY=value` syntax (see `.env.example`), or source with `set -a` to make variables available to Ansible.

### Required for `--ask-become-pass`

If your SSH user requires a password for `sudo`, add `--ask-become-pass` to the `ansible-playbook` command. Configure passwordless sudo with:

```bash
echo "your-user ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/your-user
```

## Design Principles

- **Reproducible** — Fresh Ubuntu → clone repo → run Ansible → full infrastructure
- **Declarative** — Prefer configuration over imperative scripts
- **Separated concerns** — Terraform = cloud, Ansible = OS, Argo CD = apps
- **Security-first** — Secrets are never committed; SSH-only access

## License

[Apache 2.0](LICENSE)
