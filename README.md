This is a simple Terraform script based on Google's Host a Static Website (https://cloud.google.com/storage/docs/hosting-static-website#lb-host) guide.

This was designed to be run from the Google Cloud Console and is NOT suitable for production environments.

Usage:
    - git clone <url> && cd static-website
    - bash startup.sh
            - This completes the setup and runs the necessary Terraform commands
    - 