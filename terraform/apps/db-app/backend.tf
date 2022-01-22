#
terraform {
  backend "s3" {
    profile              = "pinfos"
    region               = "us-east-2"
    bucket               = "grib-tlrk-trfm-state"
    workspace_key_prefix = "db-app"
    key                  = "./db-app.tfstate"
    dynamodb_table       = "grib-tlrk-trfm-state-locks"
  }
}