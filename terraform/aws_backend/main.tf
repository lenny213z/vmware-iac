#
resource "aws_s3_bucket" "terraform_statefile_store" {
  bucket = "grib-tlrk-trfm-state"

  lifecycle {
    prevent_destroy = false # should be true to prevent accidentally deleting state file
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
#
resource "aws_dynamodb_table" "terraform_statefile_locks" {
  hash_key     = "LockID"
  name         = "grib-tlrk-trfm-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"

  }

}