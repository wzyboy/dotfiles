plugin "terraform" {
  enabled = true
  preset  = "recommended" # default: "all"
}

rule "terraform_typed_variables" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_deprecated_interpolation" {
  enabled = false
}

plugin "aws" {
  enabled = true
  version = "0.21.1"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
