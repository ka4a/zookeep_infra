# Zookeep - Infrastructure as Code

This project is designed to create multi-stage infrastructure. 

## Requirements

- terraform = v0.14.11

## AWS account prerequisites 

It is desirable that the Amazon AWS IAM account used for infrastructure deployment an administrator type (AdministratorAccess IAM policy attached).

If this is not possible please request a full access to this resources in project's region:

- VPC
- EC2
- S3
- RDS (PostgreSQL)
- DynamoDB

# GitHub Actions

## First deploy

Very first deployment of infrastructure for specific environment must be performed manually.

## Workflow

- infra: `terraform plan` - detects infrastructure changes. `terraform apply -auto-approve` deploy infrastructure.

## GitHub Actions secrets

- `AWS_DEFAULT_REGION`, `DEV_AWS_ACCESS_KEY_ID`, `DEV_AWS_SECRET_ACCESS_KEY` - AWS credentials for DEV environment.
- `AWS_DEFAULT_REGION`, `STAGE_AWS_ACCESS_KEY_ID`, `STAGE_AWS_SECRET_ACCESS_KEY` - AWS credentials for STAGE environment.
- `AWS_DEFAULT_REGION`, `PROD_AWS_ACCESS_KEY_ID`, `PROD_AWS_SECRET_ACCESS_KEY` - AWS credentials for PROD environment.


# Manual run

NOTE: terraform code designed to run in GitHub Actions workflow
      (please refer [GitHub Actions secrets](#github-actions))

## Prepare shell to run terraform locally.
 - Create S3 bucket with uniq name (e.g. tf-dev-zookeep-state)
 - Create DynamoDB table with LockID string. Set up capacity mode to On-Demand.
 - Generate and add ssh public key in ec2 keypairs with name "ubuntu".

All variables from GitHub Actions workflow must be defined in current terminal shell:

# variables from repository secrets
```
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID="XXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXX"
export TF_VAR_pg_password="XXXXXXXXXXXXXXX"

cd dev|stage|prod
tarraform init     # only on first run
tarraform plan
terraform apply -auto-approve
```

# How to create new environment

AWS infrastructure preparation and very first deployment must be completed manually by
executing terraform, and setup of all required variables in configuration files.

1. Prepare new terraform enviroment.

  - Clone this repository to local computer.

  - Create new `env` directory from existing environment

  ```
  cp -Rap dev new_environmet_name
  ```

  - Edit `new_environmet/main.tf, backend.tf, `. Set `environment` variable as environment name,
     
2. Create DNS for env in your DNS provider panel (Route53) and point dns to new server IP. Uncoment installing packages commands in ec2 module. Update certbot command for new hostname in ec2 module "certbot --nginx -d new-env.example.com --non-interactive --agree-tos -m support@example.com". This will create ssl certificate, renewal cronjob and install it in nginx.

3. [Prepare shell to run terraform locally](#prepare-shell-to-run-terraform-locally).

4. Infrastructure preparation.

  - Code in this repository expect clean AWS account. No predefined VPC, subnetworks,
      RDP or EC2 resources expected.

5. Setup infrastructure.

```
cd new_environmet_name/
terraform init
terragrunt plan
export TF_VAR_pg_password="XXXXXXXXXX"
terraform apply -auto-approve
```

6. Prepare GitHub action flow for new environment.

  - Create new GHA flow config.

    ```
    cp .github/workflows/dev.yml .github/workflows/deploy-new_environmet.yml
    ```

  - Edit `.github/workflows/deploy-new_environmet.yml` set the value of ENVIRONMENT variable
      to name of `new_environment`. Change the `name:` of flow to descriptive text for
      `new_environment`.


  - Commit and create Pull Request to `master` branch with new GHA flow.

      ```
      git add .github/workflows/deploy-new_enviroment.yml build/config.vault.example build/config_new_enviroment.vault build/config_new_enviroment.yml
      git commit .github/workflows/deploy-new_enviroment.yml
      git push origin new_environment
      ```

  - Review and merge the PR.

  - Commit and push all changes to new branch.

  - Add/verify that variables used in GitHub Actions flow is configured in GitHub repo secrets.

    ```
    AWS_DEFAULT_REGION
    DEV|PROD|STAGE_AWS_ACCESS_KEY_ID
    DEV|PROD|STAGE_AWS_SECRET_ACCESS_KEY
    DEV|PROD|STAGE_RDS_PASS

    ```

  - Trigger new workflow on new branch to deploy app instance.

  - Test new deployment.

  - Review repository changes and merge them to `master` branch.
