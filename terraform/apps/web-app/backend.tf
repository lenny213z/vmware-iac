terraform {
  backend "local" {
    path          = "./web-app.tfstate"
    workspace_dir = "../../workspaces/web-app"
  }
}