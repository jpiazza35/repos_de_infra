module "sonatype" {
  source     = "./modules/sonatype"
  depends_on = [module.ecs]
}
