#variable "nameservers" {
# description = "The nameservers for the Route53 zone"
#  type        = list(string)

#}
variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
 
}
variable "zone_id" {
  description = "The ID of the Cloudflare zone where the NS record will be created"
  type        = string
  

}