# [![AWS CloudFormation Starter Kit header](./images/github-title-banner.png)](https://towardsthecloud.com)

# AWS CloudFormation Starter Kit

Welcome to the AWS CloudFormation Starter Kit, designed to streamline your infrastructure setup using CloudFormation templates and the Rain tool. This repository provides a structured approach to managing your AWS resources as code, ensuring efficient and reliable deployments.

<!-- TIP-LIST:START -->
> [!TIP]
> **[Towards the Cloud](https://towardsthecloud.com/about) eliminates AWS complexity so you ship faster with confidence, cut costs by 30%, and become compliant.**
>
> Sounds too good to be true? We'll assess your AWS account for free and report exactly where you stand. You'll receive a report with security findings and cost optimization opportunities. After that you can decide whether to fix these findings yourself or let us handle it. No strings attached.
>
> <a href="https://cal.com/towardsthecloud/aws-account-review"><img alt="Book a Free AWS Account Review" src="https://img.shields.io/badge/Book%20A%20Free%20AWS%20Account%20Review-success.svg?style=for-the-badge"/></a>
>
> <details>
> <summary>☁️ <strong>Discover how we cut AWS costs by 30% and accelerate SOC 2 compliance...</strong></summary>
> <br/>
>
> ### AWS complexity builds faster than you realize
>
> What starts as a simple deployment quickly spirals into inefficient architectures that cost 40-60% more than needed, security blind spots that risk customer data, and teams that burnout from managing operations on AWS instead of building product.
>
> **Traditional consultancies prioritize billable hours over outcomes, then disappear after setup. We do the opposite...**
>
> ---
>
> ### We provide a complete package, so you deploy faster with confidence on AWS Cloud
>
> - ✅ **[Compliant multi-account Landing Zone](https://towardsthecloud.com/services/aws-landing-zone)**:
>   - Provisions AWS accounts with security guardrails out of the box - 100% [CIS benchmark compliant](https://docs.aws.amazon.com/securityhub/latest/userguide/cis-aws-foundations-benchmark.html)
>   - Secure Single Sign-On (SSO) for clean user access management
>   - Everything is built using AWS CDK ensuring consistency, version control, and repeatable deployments
>   - See what features are already included in our landing zone on our [public roadmap](https://github.com/towardsthecloud/aws-cdk-landing-zone-roadmap?tab=readme-ov-file#features)
> - ✅ **Off-the-shelf compliant CDK components**: Develop secure infra quicker without reinventing the wheel
> - ✅ **Complete CI/CD with easy rollbacks**: Deploy more frequently because of IaC safety
> - ✅ **Quarterly checks**: Proactively receive [Cost Optimization assessments](https://towardsthecloud.com/services/aws-cost-optimization) + [Security Reviews](https://towardsthecloud.com/services/aws-security-review)
> - ✅ **Fractional Cloud Engineer**: On-demand access to a decade of AWS Cloud experience to help you use best practices
>
> ---
>
> ### What results can you expect when you partner with us:
>
> - **30% Lower AWS Bill**: Proactive quarterly reviews catch overspending before it happens [(30-60% documented savings)](https://towardsthecloud.com/services/aws-cost-optimization#case-study)
> - **Accelerate SOC 2/HIPAA compliance**: Our Landing Zone automatically sets up security guardrails on your AWS accounts with 100% CIS compliance from day one
> - **Easily stay compliant**: Our automated monitoring and proactive quarterly security reviews give you control so yearly audits are smooth, not stressful
> - **Your Team Ships Faster**: Our Pre-built secure infrastructure components let your team focus on product, not AWS
> - **Save on hiring costs**: Access expert Cloud knowledge through our [flexible retainer](https://towardsthecloud.com/pricing) instead of committing to a full-time Cloud Engineer
>
> **Proof:** Y Combinator startup Accolade's founder on how our Landing Zone [accelerated their SOC 2 certification](https://towardsthecloud.com/blog/aws-landing-zone-case-study-accolade):
>
> *"Danny's solution and AWS expertise stood out with comprehensive accelerators, documentation, and clearly articulated design principles. **We achieved a perfect security score in days, not months.**"* — Galen Simmons, CEO
>
> </details>
<!-- TIP-LIST:END -->

## Features

- ⚡ **Quick Setup**: Get started with your infrastructure CI/CD in minutes by configuring a couple of repository variables.
- 🌐 **Environment Flexibility**: Supports multiple environments (e.g., dev, staging, prod) via GitHub Actions workflows.
- 🤖 **Automated Validation**: Use Checkov and cfn-lint for static analysis of your CloudFormation templates, ensuring compliance and security best practices.
- 🏗️ **Modular Structure**: Organize your templates into logical components for better manageability and scalability.
- 🔒 **Security Best Practices**: Incorporate OIDC for deploying cloudformation stacks in a secure manner in your AWS account via a GitHub Actions workflow.
- 📜 **Comprehensive Documentation**: Detailed README and inline comments to guide you through setup and deployment processes.
- 🚀 **CI/CD Integration**: Ready-to-use GitHub Actions workflows for automated deployments and validations.

## Setup Guide

This project requires **Python 3** and **pip** for managing dependencies.

**To get started, follow these steps:**

1. Clone this repository:

```bash
git clone https://github.com/towardsthecloud/aws-cloudformation-starter-kit.git
cd aws-cloudformation-starter-kit
```

1. Install checkov, cfn-lint via pip & rain via homebrew:

```bash
brew install rain
pip install -r requirements.txt
```

3. Run the `provision-repo.sh` script to generate the parameter and workflow files for your environment and in the repository with your AWS account information and the necessary variables for the OIDC provider.

```bash
./scripts/provision-repo.sh
```

4. Validate your CloudFormation templates with cfn-lint and checkov using the provided script:

```bash
./scripts/validate.sh
```

5. Deploy the oidc-provider CloudFormation stack using the `deploy-templates.sh` script:

```bash
./scripts/deploy-templates.sh
```

> [!WARNING]
> Make sure that you have the required IAM role or user setup in your aws config file. Use a tool such as [Granted](https://github.com/common-fate/granted) to make accessing your AWS account via the CLI easier and more secure.


Now that you have successfully deployed the OIDC provider, you can use the following steps to configure your GitHub repository with the necessary variables, so that the CI/CD workflow can be used to deploy your CloudFormation stacks.

6. Navigate to your repository's settings page on GitHub.
   1. In the left sidebar, click on "Secrets and variables".
   2. Click on "Actions" and then "New repository variable".
   3. add the following variables:

Note: Make sure to modify the values of the variables to match your specific account and region.

![GitHub Repository Variables](./images/actions-variables.png)

You can now use the provided GitHub Actions workflows to deploy your CloudFormation stacks. Simply commit your changes to the main branch of your repository by adding new stacks to the `./templates` folder and the workflow will automatically deploy your stacks.

## Project Structure

This starter kit is organized to promote best practices in managing CloudFormation templates:

```bash
.
├── .cfnlintrc
├── .checkov.yml
├── .github
│  ├── pull-request-template.md
│  └── workflows
      ├── cfn-lint-scan.yml
│     ├── checkov-scan.yml
│     └── cloudformation-deploy-test.yml
├── LICENSE
├── parameters
│  ├── production
│  │  └── oidc-provider.yml
│  └── test
│     └── oidc-provider.yml
├── README.md
├── requirements.txt
├── scripts
│  ├── provision-repo.sh
│  ├── deploy-templates.sh
│  └── validate-templates.sh
└── templates
   └── oidc-provider.yml
```

### Key Components

- `parameters/`: This directory contains parameter files for different environments, such as `production` and `test`. Each subdirectory corresponds to an environment and contains YAML files that define parameters specific to that environment. It's important to ensure that the filename of each parameter file matches the corresponding template name in the `templates/` directory. This naming convention allows scripts to correctly associate parameters with their respective templates during deployment.
- `.cfnlintrc`: This file is the configuration for cfn-lint, a tool used to validate CloudFormation templates against AWS best practices and syntax rules.
- `.checkov.yml`: This configuration file is used by Checkov, a static analysis tool for infrastructure as code. It defines the rules and policies that Checkov will enforce when scanning your CloudFormation templates.
- `.github/workflows/`: Contains GitHub Actions workflows for CI/CD.
- - `cfn-lint-scan.yml`: Automates the validation of CloudFormation templates using cfn-lint to ensure compliance with AWS best practices and syntax rules.
- - `checkov-scan.yml`: Automates the validation of CloudFormation templates using Checkov to ensure compliance and security.
- - `cloudformation-deploy-test.yml`: Manages the deployment of CloudFormation stacks for testing purposes.
- `scripts/`: Contains shell scripts for managing templates.
- - `deploy-templates.sh`: Automates the deployment of CloudFormation templates using the Rain tool.
- - `provision-repo.sh`: Generates the parameter and workflow files for your environment and in the repository with your AWS account information and the necessary variables for the OIDC provider.
- - `validate-templates.sh`: Validates CloudFormation templates using Checkov to ensure they adhere to best practices.
- `templates/`: Stores CloudFormation templates.
- - `oidc-provider.yml`: Example template for setting up an OpenID Connect provider in AWS.

## CI/CD Integration

This starter kit includes GitHub Actions workflows for automated validation and deployment. Customize the workflows in the `.github/workflows/` directory to suit your CI/CD needs.

Checkov Scan: Automatically runs Checkov on your templates to catch security and compliance issues before deployment.
CloudFormation Deploy Test: Deploys your CloudFormation stacks in a test environment to ensure everything works as expected.

## Start adding CloudFormation templates

To start adding CloudFormation templates, simply add new files to the [`./templates`](./templates) directory and commit them to the `main` branch of your repository to trigger the CI/CD workflow. The workflow will automatically deploy your stacks using the provided parameter files.

Here are a couple of repositories containing CloudFormation templates that you can use as a starting point:

- [Official AWS CloudFormation Templates](https://github.com/aws-cloudformation/aws-cloudformation-templates)
- [Widdix's AWS CloudFormation Templates](https://github.com/widdix/aws-cf-templates)
- [AWS Quick Start Templates](https://github.com/aws-quickstart/quickstart-examples)

## AWS CDK Starter Kit

> **Looking for a more modern approach to managing your AWS infrastructure?** Consider using the [AWS CDK Starter Kit](https://github.com/towardsthecloud/aws-cdk-starter-kit) for a tailored experience that leverages the full power of AWS CDK with TypeScript.

AWS CDK offers several advantages over traditional CloudFormation, such as improved developer experience through the use of familiar programming languages, higher abstraction with reusable constructs, and seamless integration with development workflows. These features make AWS CDK a highly recommended choice for more efficient and flexible infrastructure management.

[Explore the AWS CDK Starter Kit](https://github.com/towardsthecloud/aws-cdk-starter-kit) and start building your infrastructure with greater efficiency and flexibility today!

## Acknowledgements

Special thanks to the creators of [Rain](https://github.com/aws-cloudformation/rain), [Checkov](https://github.com/bridgecrewio/checkov), and [cfn-lint](https://github.com/aws-cloudformation/cfn-lint) for their invaluable tools that make infrastructure management easier and more secure.

## Author

[Danny Steenman](https://towardsthecloud.com/about)

[![](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/company/towardsthecloud)
[![](https://img.shields.io/badge/X-000000?style=for-the-badge&logo=x&logoColor=white)](https://twitter.com/dannysteenman)
[![](https://img.shields.io/badge/GitHub-2b3137?style=for-the-badge&logo=github&logoColor=white)](https://github.com/towardsthecloud)
