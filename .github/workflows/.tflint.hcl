plugin "terraform" {
  enabled = true
  version = "0.12.0"
  preset  = "recommended"
}

plugin "google" {
    enabled = true
    version = "0.32.0"
    source  = "github.com/terraform-linters/tflint-ruleset-google"
}