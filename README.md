<!-- textlint-disable -->
[![Run Super Linter](https://github.com/gmccormick8/simple-gcp-static-website/actions/workflows/super-linter.yml/badge.svg?branch=main)](https://github.com/gmccormick8/simple-gcp-static-website/actions/workflows/super-linter.yml)

# GCP Static Website Terraform Project

This project provides Infrastructure as Code (IaC) for deploying a static website on Google Cloud Platform using Cloud Storage and Cloud Load Balancing.
The implementation is based on Google's [Host a Static Website](https://cloud.google.com/storage/docs/hosting-static-website) guide.
This project is designed to run from the Google Cloud Shell using a user-friendly startup script. Simply clone this repository, run the script (following the prompts), and let Terraform do the rest!

<!-- textlint-enable -->

## Architecture

The project creates the following resources:

- Google Cloud Storage bucket for hosting static content
- Global HTTP External Application Load Balancer
- Static IP address

## Prerequisites

- [Google Cloud Platform Account](https://console.cloud.google.com)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) - Preinstalled in Google Cloud Shell
- [Terraform](https://www.terraform.io/downloads) (version ~> 1.11.0) - Terraform is preinstalled in Google Cloud Shell
- Active Google Cloud Project with billing enabled
- Required APIs enabled:
  - compute.googleapis.com
  - storage-api.googleapis.com

## Quick Start (Google Cloud Shell)

1. Clone this repository:
<!-- textlint-disable -->

```bash
git clone https://github.com/gmccormick8/simple-gcp-static-website.git && cd simple-gcp-static-website
```

<!-- textlint-enable -->

2. Run setup script to initialize the project (enter "y" when prompted):

```bash
bash setup.sh
```

The setup script will:

- Verify and update Terraform if needed
- Enable required Google Cloud APIs
- Initialize Terraform
- Create and apply the Terraform configuration
<!-- textlint-disable -->
- Display a link to the newly created website at the end of the output. Please note that it may take several minutes for the website to go live.
<!-- textlint-enable -->

## Manual Deployment

If you prefer to deploy manually:

1. Set your Google Cloud project ID:

```bash
echo 'project_id = "YOUR_PROJECT_ID"' > terraform.tfvars
```

2. Initialize Terraform:

```bash
terraform init
```

3. Review the deployment plan:

```bash
terraform plan
```

4. Apply the configuration (enter "yes" when prompted):

```bash
terraform apply
```

## Customization

- The default index page and 404 error page can be modified in `main.tf`
- Storage bucket configuration can be adjusted in `modules/storage/main.tf`
- Load balancer settings can be modified in `modules/load-balancer/main.tf`

## Cleanup

To remove all created resources (enter "yes" when prompted):

```bash
terraform destroy
```

## Security Notes

This implementation:

- Makes the storage bucket public
- Uses HTTP (not HTTPS)
- Is intended for development/testing purposes
- Is not suitable for production use

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting pull requests.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
