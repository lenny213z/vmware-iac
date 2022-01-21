terraform {
  backend "local" {
    path          = "./db-app.tfstate"
    workspace_dir = "../../workspaces/db-app"
  }
}