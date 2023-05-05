module "iam_user" {
  source = "github.com/cisagov/ami-build-iam-user-tf-module"

  providers = {
    aws                       = aws
    aws.images-production-ami = aws.images-production-ami
    aws.images-staging-ami    = aws.images-staging-ami
    aws.images-production-ssm = aws.images-production-ssm
    aws.images-staging-ssm    = aws.images-staging-ssm
  }

  ssm_parameters = [
    "/cdm/tanium_hostname",
    "/cyhy/dev/users",
    "/openvpn/server/*",
    "/ssh/public_keys/*",
  ]
  user_name = "build-openvpn-packer"
}

# Attach 3rd party S3 bucket read-only policy from
# cisagov/ansible-role-crowdstrike to the production EC2AMICreate role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread_crowdstrike_production" {
  provider = aws.images-production-ami

  policy_arn = data.terraform_remote_state.ansible_role_crowdstrike.outputs.production_bucket_policy.arn
  role       = module.iam_user.ec2amicreate_role_production.name
}

# Attach 3rd party S3 bucket read-only policy from
# cisagov/ansible-role-crowdstrike to the staging EC2AMICreate role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread_crowdstrike_staging" {
  provider = aws.images-staging-ami

  policy_arn = data.terraform_remote_state.ansible_role_crowdstrike.outputs.staging_bucket_policy.arn
  role       = module.iam_user.ec2amicreate_role_staging.name
}

# Attach 3rd party S3 bucket read-only policy from
# cisagov/ansible-role-cdm-certificates to the production EC2AMICreate
# role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread_certificates_production" {
  provider = aws.images-production-ami

  policy_arn = data.terraform_remote_state.ansible_role_cdm_certificates.outputs.production_bucket_policy.arn
  role       = module.iam_user.ec2amicreate_role_production.name
}

# Attach 3rd party S3 bucket read-only policy from
# cisagov/ansible-role-cdm-certificates to the staging EC2AMICreate
# role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread_certificates_staging" {
  provider = aws.images-staging-ami

  policy_arn = data.terraform_remote_state.ansible_role_cdm_certificates.outputs.staging_bucket_policy.arn
  role       = module.iam_user.ec2amicreate_role_staging.name
}
