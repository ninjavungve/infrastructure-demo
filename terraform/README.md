# Zargony's Cloud Infrastructure Setup

Programmatic definition of the Zargony Cloud Infrastructure running on [Amazon AWS](https://aws.amazon.com).

## Requirements

- [AWS CLI Tools](https://aws.amazon.com/cli)
- [Terraform](https://terraform.io)

Easiest installation method is to use [Homebrew](https://brew.sh):

```sh
$ brew install awscli terraform
```

## First use

```sh
$ aws --profile zargony configure
  # Enter access key and secret key
$ terraform init
$ terraform get
```

## Usage

Dry-run:

```sh
$ terraform plan
```

Apply:

```sh
$ terraform apply
```
