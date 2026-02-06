module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  env          = var.env
}
