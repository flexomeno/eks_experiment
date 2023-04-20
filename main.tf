module "vpc" {
  source = "./modules/vpc1"

  vpc_cidr_block = "10.0.0.0/16"
}

module "eks" {
  source = "./modules/eks1"

  vpc_id        = module.vpc.vpc_id
  subnets       = [module.vpc.public_subnet_ids[0], module.vpc.public_subnet_ids[1], module.vpc.public_subnet_ids[2]]
  cluster_name  = "eks-cluster"
  instance_type = "t2.micro"
  desired_capacity = "2"
  max_size = "3"
  min_size = "1"
}