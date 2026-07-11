# ──────────────────────────────────────────────
# Cloudflare module — Tunnel and ingress config
# ──────────────────────────────────────────────

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# ── Cloudflare Tunnel ─────────────────────────
resource "cloudflare_tunnel" "homelab" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  secret     = var.tunnel_secret
}

# ── Tunnel ingress config ─────────────────────
resource "cloudflare_tunnel_config" "homelab" {
  tunnel_id  = cloudflare_tunnel.homelab.id
  account_id = var.cloudflare_account_id

  config {
    dynamic "ingress_rule" {
      for_each = var.ingress_rules
      content {
        hostname = ingress_rule.value.hostname
        service  = ingress_rule.value.service
        path     = ingress_rule.value.path
      }
    }

    # Catch-all: return 404 for unmatched routes
    ingress_rule {
      service = "http_status:404"
    }
  }
}
