# Stupid Simple CI/CD

By Max Zintel - Email: maxz@hey.com (shoot me an email with any questions!)

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

**Need something more robust? We are working on building out more free-to-use repositories to support your CI/CD and DevOps needs! Check out [Stupid Simple Autoscaling](https://github.com/maxzintel/stupid-simple-autoscaling)**

## Let's Get Started!

### Prerequisites
* An AWS account with necessary permissions.
* A GitHub account.
* Basic knowledge of Terraform, AWS ECS, and GitHub Actions.

### Step by Step

1. Clone the Repository: Begin by cloning this repo to your local machine or forking it into your GitHub account. Change the path for the GitHub Actions pipeline from `pipelines/github` to `.github` so that GitHub will recognize it automatically as a pipeline it is responsible for.
2. AWS Configuration: Set up an ECS cluster in your AWS account.
   * Name this cluster appropriately (e.g., YourCluster). Note: there is a lot of complexity here and a lot to consider. If you would like some assistance in setting your ECS cluster up, reach out!
   * You'll need to create an ECR repository in AWS as well, and create necessary AWS resources like a VPC, subnets, security groups, IAM roles, etc... Again, this can be a lot, and its really easy to make a mistake that will make your application vulnerable to attacks, so, **please reach out if you are not sure on any of this**.

3. Modify Terraform Files
   * Navigate to `infrastructure/environments/main.tf`.
   * Change Cluster Name: Replace "YourCluster" with the name of the ECS cluster you created (e.g., "MyAppCluster").
   * For the Subnets and Security Groups: Update the `subnets` and `security_groups` under `network_configuration` with your specific AWS VPC subnet IDs and security group IDs. You can find these in your AWS console.
   * For your Load Balancer ARN: Modify the `target_group_arn` in the `load_balancer` block with the ARN of your AWS load balancer target group. For your AWS Account Number: Replace `${YOUR_AWS_ACCOUNT_NUMBER}` with your actual AWS account number in appropriate places.

4. Update GitHub Workflow
   * Navigate to `.github/workflows/production.pipelines.yaml`.
   * Update your AWS Credentials: Add your AWS access key ID, secret access key, and region to your GitHub repository secrets (named `AWS_ACCESS_KEY`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`). These should be keys associated with a user specific to this deployment pipeline, following principals of least privilege.
   * ECR Repository: Replace `${YOUR_AWS_ACCOUNT_NUMBER}` with your AWS account number and update the name `example-app` to your ECR repository name.

5. Testing Locally
   * Setup Terraform locally using the following documentation: https://developer.hashicorp.com/terraform/cli
   * Navigate to `infrastructure/environments/production` in your repository.
   * Run `terraform init` to ensure terraform is setup successfully.
   * Run `terraform plan` (if you've already setup your AWS environment, including your ECS cluster) to check what your automated CI/CD _would_ be applying if you were to initiate the automated deployment right now.
     * Note you'll also need to make sure your AWS ECR has a valid image available for ECS to use.
   * Run `terraform apply` to ensure the AWS resources are able to apply as expected (this is the part where misconfiguration or permissions issues typically arise).
   * Go to your AWS Console and check ECS to watch your new Service deploy.
   * Great! All your steps work locally. Time to automate them.
 
 6. Deploying via CI/CD
    * The CI/CD process is triggered when changes are pushed to the main branch of your GitHub repository.
    * Push Your Changes: Commit and push your changes to the main branch. Ideally via a PR that was reviewed by a coworker.
    * Automatic Deployment: The GitHub Actions workflow defined in production.pipelines.yaml will automatically start. It performs the following steps:
      * Checks out your code.
      * Configures AWS credentials.
      * Builds your Docker image and pushes it to AWS ECR.
      * Updates the Docker image tag in AWS SSM.
      * Runs Terraform to apply the changes to your infrastructure. This deploys the new image of your app to ECS and does so without lapses in availability.
    
  7. Monitoring the Deployment
     * Monitor the GitHub Actions workflow (via the Actions tab at the top of this screen). Ensure it completes successfully. Once it completes, that means the new image (and task definition) has been pushed and deployed to ECS.
     * Navigate to the AWS ECS Console and watch the deployment process to ensure it proceeds as expected. One thing you don't have (included in this repository) is logging and monitoring setup to properly understand what is going on inside your ECS Task. If you would like help setting this up, reach out! My contact info is near the top of this README.
