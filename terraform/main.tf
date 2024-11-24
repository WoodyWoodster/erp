provider "aws" {
  region = "us-west-2"
}

data "aws_ssm_parameter" "private_key" {
  name            = "gndwrk-erp-private-key"
  with_decryption = true
}
