# Configure the Fastly Provider
provider "fastly" {
  api_key = "DjFKLv35tPR5fdq1uDTIZZnus1o_013t"
}

# output varialbles on the console
output "Fastly-Version" {
  value = "${fastly_service_v1.fastly-terraform-demo.active_version}"
}

# Create a Service

resource "fastly_service_v1" "first_terraform_service" {
  name = "First Fastly Terraform Service"

  domain {
    name    = "terraform.lbfastly.com"
    comment = "Terraform demo"
  }

  backend {
    address = "127.0.0.1"
    name    = "localhost"
    port    = 80
  }

  force_destroy = true
}
