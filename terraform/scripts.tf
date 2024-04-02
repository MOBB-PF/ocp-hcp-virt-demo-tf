# Creating a AWS secret

resource "aws_secretsmanager_secret" "secret" {
  count                   = var.seed.deploy == "true" ? 1 : 0
  name                    = "${var.cluster_name}-credentials"
  recovery_window_in_days = 0
  depends_on = [
    module.rhcs_cluster_rosa_hcp
  ]
}

# Creating a AWS secret versions

resource "aws_secretsmanager_secret_version" "sversion" {
  count         = var.seed.deploy == "true" ? 1 : 0
  secret_id     = aws_secretsmanager_secret.secret[0].id
  secret_string = <<EOF
   {
    "user": "cluster-admin",
    "password": "initial"
   }
EOF
}

# Generate accounts and store password and deliver helm chart.

resource "null_resource" "seed" {
  count = var.seed.deploy == "true" ? 1 : 0
  provisioner "local-exec" {
    command = "scripts/seed.sh >> output.log 2>&1"
    environment = {
      secret             = "${var.cluster_name}-credentials"
      token              = var.RHCS_TOKEN
      cluster            = var.cluster_name
      secret_id          = aws_secretsmanager_secret.secret[0].id
      helm_chart         = var.seed.helm_chart
      helm_chart_version = var.seed.helm_chart_version
    }
  }
}

