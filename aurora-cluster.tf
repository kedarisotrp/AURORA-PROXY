module "rds_proxy" {
  source = "terraform-aws-modules/rds-proxy/aws"

  name                   = "rds-proxy"
  iam_role_name          = "rds-proxy-role"
  vpc_subnet_ids         = ["subnet-0a9c320c25c5f0b5c", "subnet-038b1065af061f3c8", "subnet-0c6e3dea4e92d68b5"]
  vpc_security_group_ids = ["sg-01772b3496e99456e"]

  endpoints = {
    read_write = {
      name                   = "read-write-endpoint"
      vpc_subnet_ids         = ["subnet-0a9c320c25c5f0b5c", "subnet-038b1065af061f3c8", "subnet-0c6e3dea4e92d68b5"]
      vpc_security_group_ids = ["sg-01772b3496e99456e"]
    },
    read_only = {
      name                   = "read-only-endpoint"
      vpc_subnet_ids         = ["subnet-0a9c320c25c5f0b5c", "subnet-038b1065af061f3c8", "subnet-0c6e3dea4e92d68b5"]
      vpc_security_group_ids = ["sg-01772b3496e99456e"]
      target_role            = "READ_ONLY"
    }
  }

  auth = {
    "superuser" = {
      description        = "Aurora PostgreSQL superuser password"
      secret_arn         = "arn:aws:secretsmanager:ap-southeast-1:123456789012:secret:superuser-6gsjLD"
    }
  }

  # Target Aurora cluster
  engine_family         = "POSTGRESQL"
  target_db_cluster     = true
  db_cluster_identifier = "aws-sg-cbs-dev-rds-aurora-postgresql-001"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}