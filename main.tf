# ----------------------------------------
# Terraform Configuration & Provider
# ----------------------------------------
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# ----------------------------------------
# Variables
# ----------------------------------------
variable "cloudflare_api_token" {
  description = "Cloudflare API Token with R2 permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "bucket_name" {
  description = "Name of the R2 bucket to create"
  type        = string
  default     = "my-first-r2-bucket"
}

variable "location" {
  description = "Location hint for the R2 bucket"
  type        = string
  default     = "WNAM" # Western North America
  # Other options: ENAM, WEUR, EEUR, APAC, OC
}

# ----------------------------------------
# R2 Bucket Resource
# ----------------------------------------
resource "cloudflare_r2_bucket" "this" {
  account_id = var.cloudflare_account_id
  name       = var.bucket_name
  location   = var.location
}

# ----------------------------------------
# CORS Configuration (Commented)
# ----------------------------------------
# Uncomment and customize to enable CORS for your bucket
# resource "cloudflare_r2_bucket_cors_configuration" "this" {
#   account_id = var.cloudflare_account_id
#   bucket     = cloudflare_r2_bucket.this.name
#
#   cors_rule {
#     allowed_origins = ["https://example.com"]
#     allowed_methods = ["GET", "PUT", "POST"]
#     allowed_headers = ["*"]
#     max_age_seconds = 3000
#   }
# }

# ----------------------------------------
# Outputs
# ----------------------------------------
output "bucket_name" {
  description = "Name of the created R2 bucket"
  value       = cloudflare_r2_bucket.this.name
}

output "bucket_location" {
  description = "Location of the R2 bucket"
  value       = cloudflare_r2_bucket.this.location
} 