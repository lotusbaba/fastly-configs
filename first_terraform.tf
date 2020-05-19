# Configure the Fastly Provider
provider "fastly" {
  api_key = "DjFKLv35tPR5fdq1uDTIZZnus1o_013t"
}

# Create a Service

resource "fastly_service_v1" "first_terraform_service" {
  name = "My First Terraform Service"

  domain {
    name    = "demo.notexample.com"
    comment = "demo"
  }

  backend {
    address = "127.0.0.1"
    name    = "localhost"
    port    = 80
  }

  force_destroy = true
}
