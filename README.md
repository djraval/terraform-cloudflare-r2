# terraform-cloudflare-r2

A Terraform configuration for creating and managing Cloudflare R2 buckets.

## Repository Structure

This repository uses a simplified structure:

- `main.tf` - The complete Terraform configuration (provider, variables, resources, outputs)
- `terraform.tfvars` - Configuration values (API tokens, account ID, bucket settings)
- `.gitignore` - Prevents sensitive data and Terraform state files from being committed

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0+)
- Cloudflare account with R2 storage enabled
- Cloudflare API token with R2 permissions

## Setup Instructions

1. **Cloudflare Credentials**
   - Create an API token in your Cloudflare dashboard with R2 permissions
   - Note your Cloudflare account ID (found in your dashboard URL)
   - Update these values in `terraform.tfvars`

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Preview Changes**
   ```bash
   terraform plan
   ```

4. **Apply Configuration**
   ```bash
   terraform apply
   ```
   Type "yes" when prompted to confirm.

5. **Destroy Resources** (when no longer needed)
   ```bash
   terraform destroy
   ```

## Customizing Your Configuration

### Adding Another Bucket

To add another R2 bucket, add a new resource block to `main.tf`:

```hcl
resource "cloudflare_r2_bucket" "another_bucket" {
  account_id = var.cloudflare_account_id
  name       = "my-second-bucket" 
  location   = var.location
}
```

### Adding CORS Configuration

Uncomment and modify the CORS configuration in `main.tf` to enable cross-origin requests:

```hcl
resource "cloudflare_r2_bucket_cors_configuration" "this" {
  account_id = var.cloudflare_account_id
  bucket     = cloudflare_r2_bucket.this.name

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}
```

## Working with Non-Empty Buckets

When changing a bucket name or location, you may encounter the following error if the bucket contains objects:

```
Error: failed to delete R2 bucket

The bucket you tried to delete (my-first-r2-bucket) is not empty 
```

This occurs because:
1. Terraform attempts to delete the old bucket
2. Cloudflare prevents deletion of non-empty buckets

## Cloudflare R2 Locations

Available location values:
- `WNAM` - Western North America
- `ENAM` - Eastern North America
- `WEUR` - Western Europe
- `EEUR` - Eastern Europe
- `APAC` - Asia Pacific
- `OC` - Oceania 