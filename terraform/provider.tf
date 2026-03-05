terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.33.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.29.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
} 

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# create record in cloudflare
resource "cloudflare_record" "route53_ns" {
  zone_id = var.zone_id
  name    = "url"
  count   = "4"
  type    = "NS"
  value   = module.Route53.nameserver[count.index]
  ttl     = 300
}