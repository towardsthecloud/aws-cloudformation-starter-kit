# [![AWS CloudFormation Starter Kit header](./images/github-title-banner.png)](https://towardsthecloud.com)

# AWS CloudFormation Starter Kit

Welcome to the AWS CloudFormation Starter Kit, designed to streamline your infrastructure setup using CloudFormation templates and the Rain tool. This repository provides a structured approach to managing your AWS resources as code, ensuring efficient and reliable deployments.

## 🚀 Features

- ⚡ **One-Command Setup**: Single bootstrap script automatically sets up your infrastructure pipeline
  - Generates environment-specific parameter files
  - Provisions OIDC provider for secure keyless authentication
  - Auto-generates GitHub Actions workflows for CI/CD
- 🔒 **Secure Deployments**: Deploy stacks via OIDC-authenticated GitHub Actions—no long-lived IAM credentials needed
- 🤖 **Pre-Commit Validation**: cfn-lint and Checkov catch issues before deployment
- 🌐 **Multi-Environment Support**: Separate parameter files for dev, staging, and production with isolated workflows

<!-- TIP-LIST:START -->
> [!TIP]
> **Catch AWS waste before and after you deploy.**
>
> [CloudBurn](https://cloudburn.io) is a free, open-source CLI that checks your Terraform and CloudFormation for costly patterns before deploy, then finds the waste already running in your AWS account. Run it locally or in CI.
>
> <a href="https://github.com/towardsthecloud/cloudburn"><img alt="Get the free CloudBurn CLI on GitHub" src="https://img.shields.io/badge/Get%20the%20free%20CLI-GitHub-brightgreen.svg?style=for-the-badge&logo=github"/></a>
>
> Want it managed across your AWS accounts? [CloudBurn Platform](https://cloudburn.io) runs it for you and keeps scan results in your own account. Join the waitlist for 30% off.
<!-- TIP-LIST:END -->

## Quick Start

This project requires **Python 3** and **pip** for managing dependencies.

**To get started, follow these steps:**

1. Click the green ["Use this template"](https://github.com/new?template_name=aws-cloudformation-starter-kit&template_owner=towardsthecloud) button to create a new repository based on this starter kit.

2. Install checkov, cfn-lint via pip & rain via homebrew:

```bash
brew install rain
pip install -r requirements.txt
```

3. Run the `provision-repo.sh` script to generate the parameter and workflow files for your environment:

```bash
./scripts/provision-repo.sh
```

4. Validate your CloudFormation templates:

```bash
./scripts/validate.sh
```

5. Deploy the oidc-provider CloudFormation stack:

```bash
./scripts/deploy-templates.sh
```

> [!WARNING]
> Make sure that you have the required IAM role or user setup in your aws config file. Use a tool such as [Granted](https://github.com/common-fate/granted) to make accessing your AWS account via the CLI easier and more secure.

6. Navigate to your repository's settings on GitHub and configure the Actions variables as shown below:

![GitHub Repository Variables](./images/actions-variables.png)

You can now deploy your CloudFormation stacks by committing changes to the main branch.

## Full Documentation

For complete details on how this starter kit works, advanced configuration options, and best practices, visit the official documentation:

**[View Full Documentation →](https://towardsthecloud.com/docs/aws-cloudformation-starter-kit)**

## AWS CDK Starter Kit

> **Looking for a more modern approach to managing your AWS infrastructure?** Consider using the [AWS CDK Starter Kit](https://github.com/towardsthecloud/aws-cdk-starter-kit) for a tailored experience that leverages the full power of AWS CDK with TypeScript.

## Acknowledgements

Special thanks to the creators of [Rain](https://github.com/aws-cloudformation/rain), [Checkov](https://github.com/bridgecrewio/checkov), and [cfn-lint](https://github.com/aws-cloudformation/cfn-lint) for their invaluable tools that make infrastructure management easier and more secure.

## Author

[Danny Steenman](https://towardsthecloud.com/about)

[![](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/company/towardsthecloud)
[![](https://img.shields.io/badge/X-000000?style=for-the-badge&logo=x&logoColor=white)](https://twitter.com/dannysteenman)
[![](https://img.shields.io/badge/GitHub-2b3137?style=for-the-badge&logo=github&logoColor=white)](https://github.com/towardsthecloud)
