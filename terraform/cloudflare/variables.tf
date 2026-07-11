# ──────────────────────────────────────────────
# Cloudflare module — Input variables
# ──────────────────────────────────────────────

variable "cloudflare_api_token" {
  description = "Cloudflare API token with permissions to manage DNS and Tunnels."
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID (found in the Cloudflare dashboard URL or under Account Settings)."
  type        = string
}

variable "zone_id" {
  description = "Cloudflare zone ID for the domain managed by this module."
  type        = string
}
variable "tunnel_secret" {
  description = "Pre-generated 32-byte base64-encoded tunnel secret shared with the Ansible cloudflared role. Generate with: openssl rand -base64 32"
  type        = string
  sensitive   = true
}

variable "tunnel_name" {
  description = "Name of the Cloudflare Tunnel resource."
  type        = string
  default     = "homelab-tunnel"
}

variable "ingress_rules" {
  description = "List of ingress rules for the Cloudflare Tunnel. Each rule maps a hostname to a backend service URL."
  type = list(object({
    hostname = string
    service  = string
    path     = optional(string)
  }))
  default = []
}
