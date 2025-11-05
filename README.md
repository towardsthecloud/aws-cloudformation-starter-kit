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
> **Towards the Cloud runs the AWS foundation for modern product teams. This means your team ships faster, slashes AWS spend, and stay audit-ready without having to hire a platform squad.**
>
> Unsure where to start? Book a free AWS Account Review. We’ll analyse your AWS environment, hand you a security & cost report, and you decide whether to act on it yourself or have us execute. No pressure, no retainer required up front.
>
> <a href="https://cal.com/towardsthecloud/aws-account-review"><img alt="Book a Free AWS Account Review" src="https://img.shields.io/badge/Book%20A%20Free%20AWS%20Account%20Review-success.svg?style=for-the-badge"/></a>
>
> <details>
> <summary>☁️ <strong>See how we turn AWS chaos into a compliant, cost-efficient platform…</strong></summary>
> <br/>
>
> ### The problem: AWS complexity compounds fast
>
> Ad‑hoc builds become 40–60% overspend, unmonitored security gaps put customer data at risk, and engineers burn out running infrastructure instead of shipping products.
>
> ### Our managed foundation keeps you moving forward
>
> - ✅ **Compliant Landing Zone** – [Multi-account AWS CDK deployment](https://towardsthecloud.com/services/aws-landing-zone) with 100% [CIS benchmark](https://docs.aws.amazon.com/securityhub/latest/userguide/cis-aws-foundations-benchmark.html) coverage,
> centralized logging, and SSO-ready access control.
> - ✅ **Production-ready CDK components** – Pre-hardened building blocks so teams launch new services without reinventing best practices.
> - ✅ **CI/CD with safe rollbacks** – GitOps workflows and governed pipelines that let you release faster with confidence.
> - ✅ **Quarterly cost & security reviews** – [Cost Optimisation](https://towardsthecloud.com/services/aws-cost-optimization) plus [Security Reviews](https://towardsthecloud.com/services/aws-security-review)
> delivered proactively.
> - ✅ **Fractional Cloud Engineer** – On-demand expertise from an architect who implemented enterprise-grade AWS infrastructure for over a decade.
>
> ### Outcomes our customers see
>
> - **30%+ lower AWS bill** – Continuous oversight prevents expensive drift ([30–60% documented savings](https://towardsthecloud.com/services/aws-cost-optimization#case-study)).
> - **SOC 2 / HIPAA acceleration** – Guardrails, logging, and evidence packs ready on day one.
> - **Audit-ready every quarter** – Automated monitoring plus recurring reviews keep findings under control.
> - **Faster product velocity** – Engineers build features, not managing infrastructure.
> - **Headcount leverage** – A [flexible retainer](https://towardsthecloud.com/pricing) replaces the cost of a full-time platform team.
>
> **Proof:** Y Combinator startup Accolade used our Landing Zone to [earn SOC 2 in record time](https://towardsthecloud.com/blog/aws-landing-zone-case-study-accolade):
>
> *“We achieved a perfect security score in days, not months.”* — Galen Simmons, CEO
>
> Ready to see where your AWS account stands? Grab a spot while they’re available:
>
> <a href="https://cal.com/towardsthecloud/aws-account-review"><img alt="Book a Free AWS Account Review" src="https://img.shields.io/badge/Book%20A%20Free%20AWS%20Account%20Review-success.svg?style=for-the-badge"/></a>
>
> </details>
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
