# ──────────────────────────────────────────────
# Cloudflare module — DNS records
# ──────────────────────────────────────────────

locals {
  tunnel_records = {
    wildcard = { name = "*" }
    root     = { name = "@" }
  }
}

resource "cloudflare_record" "tunnel" {
  for_each = local.tunnel_records

  zone_id = var.zone_id
  name    = each.value.name
  value   = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
  comment = "Cloudflare Tunnel: ${cloudflare_tunnel.homelab.name}"
}
