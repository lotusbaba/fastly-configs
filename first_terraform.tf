# Configure the Fastly Provider
provider "fastly" {
}

# output varialbles on the console
output "Fastly-Version" {
  value = "${fastly_service_v1.first_terraform_service.active_version}"
}

# Create a Service

resource "fastly_service_v1" "first_terraform_service" {
  name = "First Fastly Terraform Service"

  domain {
    name    = "terraform.lbfastly.com"
    comment = "Terraform demo"
  }

  domain {
    name    = "terraform-2.lbfastly.com"
    comment = "Terraform demo"
  }

  backend {
    address = "127.0.0.1"
    name    = "localhost"
    port    = 80
  }

 snippet {
   name     = "Change_jpg_ttl"
   type     = "recv"
   priority = 8
   content = "if ( req.url ~ \"\\.(jpeg|jpg|gif)$\" ) {\n # jpeg/gif TTL\n set beresp.ttl = 172800s;\n }\n set beresp.http.Cache-Control = \"max-age=\" beresp.ttl;"
 }

  force_destroy = true
}

