#
data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket  = "grib-tlrk-trfm-state"
    key     = "base/${terraform.workspace}/base.tfstate"
    region  = "us-east-2"
    profile = "pinfos"
    encrypt = true
  }
}
