data "terraform_remote_state" "foo" {
  backend = "remote"

  config = {
    organization = "Fastly-Sales-Engineering"
    
    hostname = "app.terraform.io"

    workspaces = {
      name = "Sales-Engineering"
    }
  }
}
