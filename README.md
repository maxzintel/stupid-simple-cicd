# Stupid Simple CI/CD

Welcome to "Stupid Simple CI/CD" - your open-source toolkit for effortless app deployment using ECS, Terraform, and GitHub Actions. This repository is a testament to simplicity in DevOps, engineered for businesses seeking reliability and efficiency in their deployment processes.

## Why Use Stupid Simple CI/CD?
* Free and Open-Source: Access top-tier deployment strategies at no cost.
* Expert-Designed: Crafted by a seasoned DevOps resource.
* Simplicity Meets Sophistication: Easy to understand, yet powerful in execution.
* Customizable: Tailor it to fit your unique business requirements.

## What's Inside?
This repository contains everything you need to set up an automated deployment pipeline:

* Terraform Scripts: Pre-written scripts for AWS ECS service setup, ensuring secure and scalable deployments.
* GitHub Action Workflows: Automated workflows for continuous integration and deployment.
* Comprehensive Documentation: Documentation that a 5 year old could use to set this up for your company.

## Let's Get Started!

### Prerequisites
* An AWS account with necessary permissions.
* A GitHub account.
* Basic knowledge of Terraform, AWS ECS, and GitHub Actions.

1. Clone the Repository: Begin by cloning this repo to your local machine or forking it into your GitHub account.
2. AWS Configuration: Set up an ECS cluster in your AWS account.

Name this cluster appropriately (e.g., YourCluster). Note: there is a lot of complexity here and a lot to consider. If you would like some assistance in setting your ECS cluster up, reach out! You'll need to create an ECR repository in AWS as well, and create necessary AWS resources like a VPC, subnets, security groups, IAM roles, etc... Again, this can be a lot, and its really easy to make a mistake that will make your application vulnerable to attacks, so, please reach out if you are not sure on any of this.

3. Modify Terraform Files

Navigate to `infrastructure/environments/main.tf`. Change Cluster Name: Replace "YourCluster" with the name of the ECS cluster you created (e.g., "MyAppCluster"). For the Subnets and Security Groups: Update the `subnets` and `security_groups` under `network_configuration` with your specific AWS VPC subnet IDs and security group IDs. You can find these in your AWS console. For your Load Balancer ARN: Modify the `target_group_arn` in the `load_balancer` block with the ARN of your AWS load balancer target group. For your AWS Account Number: Replace `${YOUR_AWS_ACCOUNT_NUMBER}` with your actual AWS account number in appropriate places.

4. Update GitHub Workflow

Navigate to `.github/workflows/production.pipelines.yaml`. Update your AWS Credentials: Add your AWS access key ID, secret access key, and region to your GitHub repository secrets (named AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY, AWS_REGION). These should be keys associated with a user specific to this deployment pipeline, following principals of least privilege. ECR Repository: Replace ${YOUR_AWS_ACCOUNT_NUMBER} with your AWS account number and update example-app to your ECR repository name.

