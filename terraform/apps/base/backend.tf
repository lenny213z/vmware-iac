terraform {
  backend "local" {
    path          = "./base.tfstate"
    workspace_dir = "../../workspaces/base"
  }
}