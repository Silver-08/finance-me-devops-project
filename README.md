Insure-Me DevOps Project
This project uses:

Git

Maven

Jenkins

Docker

Ansible

Terraform

Prometheus & Grafana

What’s inside this repo?
jenkins/Jenkinsfile — Jenkins pipeline script

docker/Dockerfile — Docker build file

ansible/playbook.yaml — Ansible setup

terraform/ — Terraform scripts to create AWS servers

prometheus/ and grafana/ — Monitoring setup

How to run this?
Clone this repo

Run Terraform from terraform/ folder to create servers

Run Ansible from your local machine to configure the servers

Jenkins (on AWS) will run the pipeline to build, test, dockerize, and deploy the app

Monitoring with Prometheus and Grafana will track server metrics

Important!
Jenkins pulls the app code from the public repo: https://github.com/StarAgileDevOpsTraining/star-agile-banking-finance.git

Docker Hub ID used: silvy08

Update IP addresses in the Ansible inventory after creating servers

Jenkins credentials store needs your Docker Hub login saved as dockerhub-credentials
