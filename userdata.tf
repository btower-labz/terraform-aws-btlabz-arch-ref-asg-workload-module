variable "userdata" {
  description = "Override module's userdata"
  type        = string
  default     = ""
}

// Instance runtime configuration files

locals {
  env_cloud_prefix = templatefile("${path.module}/templates/.env-cloud-prefix", {
    prefix = "/dev"
    # TODO: HardCode
    region = "eu-west-1"
  })
}

// Cloud init YAML

locals {
  cloud_init = templatefile("${path.module}/templates/cloud-init.yml", {
    b64_env_cloud_prefix  = "${base64encode(local.env_cloud_prefix)}",
    path_env_cloud_prefix = "/usr/local/src/django-dashboard-black/.env-cloud-prefix"
  })
}

// Provision scripts

locals {
  bootstrap_script_default     = templatefile("${path.module}/templates/bootstrap-default.sh", {})
  bootstrap_script_ssm_agent   = templatefile("${path.module}/templates/bootstrap-ssm-agent.sh", {})
  bootstrap_script_aws_cli     = templatefile("${path.module}/templates/bootstrap-aws-cli.sh", {})
  bootstrap_script_code_deploy = templatefile("${path.module}/templates/bootstrap-code-deploy.sh", {})
  bootstrap_script_inspector   = templatefile("${path.module}/templates/bootstrap-inspector.sh", {})
  bootstrap_script_docker      = templatefile("${path.module}/templates/bootstrap-docker.sh", {})
  bootstrap_script_secrets = templatefile("${path.module}/templates/bootstrap-secrets.sh", {
    api_url         = format("%s/api-url", var.config_path)
    api_key         = format("%s/api-key", var.config_path)
    database_secret = format("%s/database", var.config_path)
  })
  bootstrap_script_app = templatefile("${path.module}/templates/bootstrap-app.sh", {})
}

// Multipart config

data "template_cloudinit_config" "main" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "ud_cloud_init"
    content_type = "text/cloud-config"
    content      = local.cloud_init
  }

  part {
    filename     = "ud_script_default"
    content_type = "text/x-shellscript"
    content      = local.bootstrap_script_default
  }

  part {
    filename     = "ud_script_ssm_agent"
    content_type = "text/x-shellscript"
    content      = local.bootstrap_script_ssm_agent
  }

  part {
    filename     = "ud_script_aws_cli"
    content_type = "text/x-shellscript"
    content      = local.bootstrap_script_aws_cli
  }

  part {
    filename     = "ud_script_code_deploy"
    content_type = "text/x-shellscript"
    content      = local.bootstrap_script_code_deploy
  }

  part {
    filename     = "ud_script_inspector"
    content_type = "text/x-shellscript"
    content      = local.bootstrap_script_inspector
  }

  part {
    filename     = "ud_script_docker"
    content_type = "text/x-shellscript"
    content      = local.bootstrap_script_docker
  }

  part {
    filename     = "ud_script_secrets"
    content_type = "text/x-shellscript"
    content      = local.bootstrap_script_secrets
  }

  part {
    filename     = "ud_script_app"
    content_type = "text/x-shellscript"
    content      = local.bootstrap_script_app
  }

}

// Final userdata script

locals {
  userdata = "${var.userdata == "" ? data.template_cloudinit_config.main.rendered : var.userdata}"
}
