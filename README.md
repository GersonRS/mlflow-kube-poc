<!--
*** Thank you for viewing our README. if you have any suggestion
*** that can improve it even more fork the repository and create a Pull
*** Request or open an Issue with the tag "suggestion".
*** Thank you again! Now let's run this amazing project :D
-->
# MLflow on Kubernetes (PoC)
<!-- PROJECT SHIELDS -->

[![npm](https://img.shields.io/badge/type-Open%20Project-green?&style=plastic)](https://img.shields.io/badge/type-Open%20Project-green)
[![GitHub last commit](https://img.shields.io/github/last-commit/GersonRS/mlflow-kube-poc?logo=github&style=plastic)](https://github.com/GersonRS/mlflow-kube-poc/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/gersonrs/mlflow-kube-poc?logo=github&style=plastic)](https://github.com/GersonRS/mlflow-kube-poc/issues)
[![GitHub Language](https://img.shields.io/github/languages/top/gersonrs/mlflow-kube-poc?&logo=github&style=plastic)](https://github.com/GersonRS/mlflow-kube-poc/search?l=python)
[![GitHub Repo-Size](https://img.shields.io/github/repo-size/GersonRS/mlflow-kube-poc?logo=github&style=plastic)](https://img.shields.io/github/repo-size/GersonRS/mlflow-kube-poc)
[![GitHub Contributors](https://img.shields.io/github/contributors/GersonRS/mlflow-kube-poc?logo=github&style=plastic)](https://img.shields.io/github/contributors/GersonRS/mlflow-kube-poc)
[![GitHub Stars](https://img.shields.io/github/stars/GersonRS/mlflow-kube-poc?logo=github&style=plastic)](https://img.shields.io/github/stars/GersonRS/mlflow-kube-poc)
[![NPM](https://img.shields.io/github/license/GersonRS/mlflow-kube-poc?&style=plastic)](LICENSE)
[![Status](https://img.shields.io/badge/status-active-success.svg)](https://img.shields.io/badge/status-active-success.svg)


<p align="center">
  <img alt="logo" src=".github/assets/images/logo.png"/>
</p>


## Overview
ML-Kube is a comprehensive Machine Learning infrastructure project built on top of Kubernetes. It leverages Terraform to automate the setup of the Kubernetes cluster using kind (Kubernetes IN Docker). The infrastructure includes essential components such as MetalLB, ArgoCD, Traefik, Cert-Manager, Keycloak, Minio, Postgres, MLflow, and JupyterHub, providing a seamless development and management environment for Machine Learning applications.

## Table of Contents

- [Objective](#objective)
- [Versioning Flow](#versioning-flow)
- [Tools](#tools)
- [Getting Started](#getting-started)
- [Requirements](#requirements)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributions](#sontributions)
- [License](#license)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

## Objective
The main objective of this POC is to study and understand the functionalities of MLflow within a Kubernetes environment. By leveraging Terraform and kind, the project can be easily set up to provide a practical playground for exploring MLflow's capabilities for model management, deployment, and tracking.


## Versioning Flow
We follow the [Semantic Versioning](https://semver.org/) and [gitflow](https://www.atlassian.com/br/git/tutorials/comparing-workflows/gitflow-workflow) for versioning this project. For the versions available, see the tags on this repository.

## Tools
The following tools are used in this project:

* **Terraform:** Infrastructure-as-Code tool used to automate the setup of the Kubernetes cluster and related resources.

* **Kubernetes (kind)**: A lightweight Kubernetes implementation that allows running Kubernetes clusters inside Docker containers.

* **MetalLB**: A Load Balancer for Kubernetes environments, enabling external access to services in the local environment.

* **ArgoCD**: A GitOps Continuous Delivery tool for Kubernetes, facilitating the management of applications.

* **Traefik**: An Ingress Controller for Kubernetes, routing external traffic to applications within the cluster.

* **Cert-Manager**: A certificate management tool, enabling the use of HTTPS for applications.

* **Keycloak**: An identity management and access control service, securing applications and resources.

* **Minio**: A cloud storage server compatible with Amazon S3, providing object storage for applications.

* **Postgres**: A relational database used to store application data.

* **MLflow**: A Machine Learning lifecycle management platform, simplifying the deployment and tracking of ML models.

* **JupyterHub**: A multi-user Jupyter environment, allowing users to write and share code collaboratively.

These tools together enable the creation of a complete infrastructure for the development and management of Machine Learning applications in the Kubernetes environment.

## Requirements
To use MLflow-Kube, you need to have the following prerequisites installed and configured:

1. Terraform:
    * Installation: Visit the [Terraform website](https://www.terraform.io/downloads.html) and follow the instructions for your operating system.
2. Docker:
    * Installation: Install Docker by following the instructions for your operating system from the [Docker website](https://docs.docker.com/get-docker/).
3. Kubernetes CLI (kubectl):
    * Installation: Install `kubectl` by following the instructions for your operating system from the [Kubernetes website](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
4. Helm:
    * Installation: Install Helm by following the instructions for your operating system from the [Helm website](https://helm.sh/docs/intro/install/).

## Getting Started
To get started with the MLflow POC, follow these steps:

1. Clone this repository to your local computer.
    - `git clone https://github.com/GersonRS/mlflow-kube-poc.git`
2. Change directory to the repository:
    - `cd mlflow-kube-poc`
>Make sure you have Terraform installed on your system, along with other necessary dependencies.
3. Run `terraform init` to initialize Terraform configurations.
* ```sh
  terraform init
  ```
>`This command will download the necessary Terraform plugins and modules.`
4. Run `terraform apply` to start the provisioning process. Wait until the infrastructure is ready for use.
* ```
  terraform apply
  ```
>`Review the changes to be applied and confirm with yes when prompted. Terraform will now set up the Kubernetes cluster and deploy the required resources.`
5. After the Terraform apply is complete, the output will display URLs for accessing the applications. Use the provided URLs to interact with the applications.
6. The Terraform output will also provide the credentials necessary for accessing and managing the applications.


## Usage
Once the infrastructure is ready, you can utilize the installed applications, including MLflow, to track and manage your Machine Learning experiments. Access the applications through the provided URLs and log in using the credentials generated during setup.


## Project Structure
This project follows a structured directory layout to organize its resources effectively:
```sh
    .
    ├── LICENSE
    ├── locals.tf
    ├── main.tf
    ├── modules
    │   ├── argocd
    │   ├── cert-manager
    │   ├── jupyterhub
    │   ├── keycloak
    │   ├── kind
    │   ├── kube-prometheus-stack
    │   ├── metallb
    │   ├── minio
    │   ├── mlflow
    │   ├── oidc
    │   ├── postgresql
    │   └── traefik
    ├── outputs.tf
    ├── README.md
    ├── s3_buckets.tf
    ├── struct.txt
    ├── terraform.tf
    └── variables.tf

    15 directories, 83 files
```

* [**LICENSE**](LICENSE) - License file of the project.
* [**locals.tf**](locals.tf) - Terraform locals file.
* [**main.tf**](main.tf) - Main Terraform configuration file.
* [**modules**](modules/) - Directory containing all the Terraform modules used in the project.
  * [**argocd**](modules/argocd/) - Directory for configuring ArgoCD application.
  * [**cert-manager**](modules/cert-manager/) - Directory for managing certificates using Cert Manager.
  * [**jupyterhub**](modules/jupyterhub/) - Directory for setting up JupyterHub application.
  * [**keycloak**](modules/keycloak/) - Directory for installing and configuring Keycloak.
  * [**kind**](modules/kind/) - Directory for creating a Kubernetes cluster using Kind.
  * [**metallb**](modules/metallb/) - Directory for setting up MetalLB, a load balancer for Kubernetes.
  * [**minio**](modules/minio/) - Directory for deploying and configuring Minio for object storage.
  * [**mlflow**](modules/mlflow/) - Directory for setting up MLflow, a machine learning lifecycle management platform.
  * [**oidc**](modules/oidc/) - Directory for OpenID Connect (OIDC) configuration.
  * [**postgresql**](modules/postgresql/) - Directory for deploying and configuring PostgreSQL database.
  * [**traefik**](modules/traefik/) - Directory for setting up Traefik, an ingress controller for Kubernetes.
* [**outputs.tf**](outputs.tf) - Terraform outputs file.
* [**README.md**](README.md) - Project's README file, containing important information and guidelines.
* [**s3_buckets.tf**](s3_buckets.tf) - Terraform configuration for creating S3 buckets.
* [**terraform.tf**](terraform.tf) - Terraform configuration file for initializing the project.
* [**variables.tf**](variables.tf) - Terraform variables file, containing input variables for the project.

## Contributions
Contributions are welcome! Feel free to create a pull request with improvements, bug fixes, or new features. Contributions are what make the open source community an amazing place to learn, inspire, and create. Any contribution you make will be greatly appreciated.

To contribute to the project, follow the steps below:

1. Fork the project.
2. Create a branch for your contribution (git checkout -b feature-mycontribution).
3. Make the desired changes to the code.
4. Commit your changes (git commit -m 'MyContribution: Adding new feature').
5. Push the branch to your Fork repository (git push origin feature-mycontribution).
6. Open a Pull Request on the main branch of the original project. Describe the changes and wait for the community's review and discussion.

We truly value your interest in contributing to the MLflow-Kube project. Together, we can make it even better!

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact
For any inquiries or questions, please contact:

<p align="center">

 <a href="https://twitter.com/gersonrs3" target="_blank" >
     <img alt="Twitter" src="https://img.shields.io/badge/-Twitter-9cf?logo=Twitter&logoColor=white"></a>

  <a href="https://instagram.com/gersonrsantos" target="_blank" >
    <img alt="Instagram" src="https://img.shields.io/badge/-Instagram-ff2b8e?logo=Instagram&logoColor=white"></a>

  <a href="https://www.linkedin.com/in/gersonrsantos/" target="_blank" >
    <img alt="Linkedin" src="https://img.shields.io/badge/-Linkedin-blue?logo=Linkedin&logoColor=white"></a>

  <a href="https://t.me/gersonrsantos" target="_blank" >
    <img alt="Telegram" src="https://img.shields.io/badge/-Telegram-blue?logo=Telegram&logoColor=white"></a>

  <a href="mailto:gersonrodriguessantos8@gmail.com" target="_blank" >
    <img alt="Email" src="https://img.shields.io/badge/-Email-c14438?logo=Gmail&logoColor=white"></a>

</p>


## Acknowledgments
We appreciate your interest in using MLflow on Kubernetes PoC. We hope this configuration simplifies the management of your Machine Learning experiments on Kubernetes! 🚀📊