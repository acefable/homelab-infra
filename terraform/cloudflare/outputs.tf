output "tunnel_id" {
  description = "Cloudflare Tunnel ID."
  value       = cloudflare_tunnel.homelab.id
}

output "tunnel_cname" {
  description = "Cloudflare Tunnel CNAME target (use for DNS CNAME records)."
  value       = cloudflare_tunnel.homelab.cname
}

output "tunnel_name" {
  description = "Cloudflare Tunnel name."
  value       = cloudflare_tunnel.homelab.name
}

output "tunnel_token" {
  description = "Cloudflare Tunnel token (use with cloudflared tunnel run --token)."
  value       = cloudflare_tunnel.homelab.tunnel_token
  sensitive   = true
}
