[![binary-braids](./src/img/binary-braids-logo.png)](https://www.github.com/binary-braids)

# [binary-braids/github-actions-runner](https://github.com/binary-braids/github-actions-runner)

A self-hosted runner is a system that you deploy and manage to execute jobs from GitHub Actions on GitHub.com

![GitHub Actions](https://github.com/binary-braids/github_actions_runner/actions/workflows/main.yml/badge.svg)
[![Trivy](https://img.shields.io/badge/trivy-enabled-brightgreen?style=for-the-badge&logo=trivy)](https://trivy.dev)
[![HitCount](https://hits.dwyl.com/binary-braids/github-actions-runner.svg?style=for-the-badge&show=unique)](http://hits.dwyl.com/binary-braids/github-actions-runner)

[![github](./src/img/github-mark.png)](https://www.github.com)

## Table of Contents

- [Configuration](#configuration)
  - [Prerequisites](#prerequisites)
  - [Required Environment Variables](#required-environment-variables)
  - [Optional Environment Variables](#optional-environment-variables)
- [Available Architecture](#available-architecture)
- [Examples](#examples)
  - [Docker Compose](#docker-compose)
  - [Docker CLI](#docker-cli)
- [Support](#support)
  - [Issues](#issues)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)

## Configuration

### Prerequisites

You will need to generate a GitHub Personal Access Token to use with the container image. This will allow the runner to register with your specified organization. 

To generate a token follow this guide: [Managing your personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)


>[!NOTE]
> You will need to grant the `Read and write` permissions under `Self-hosted runners` for Fine-grained tokens or `manage_runners:org` permissions for classic tokens

### Required Environment Variables

| Variable | Description |
| ---- | --- |
| ORGANIZATION | The GitHub Organization Name |
| ACCESS_TOKEN | The Access Token to allow the runner to register to the organization. |

### Optional Environment Variables

| Variable | Description |
| ---- | --- |
| USE_HOSTNAME | If set to `TRUE` then the container name will be used as the runner name. Defaults to `FALSE` |
| CUSTOM_NAME | Use this option to configure a custom name for the runner |

## Available Architecture

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64-\<version tag\> |

## Examples

### Docker Compose

```yaml
services:
  github-actions-runner:
    image: ghcr.io/binary-braids/github-actions-runner:latest
    container_name: github-actions-runner
    environment:
      - ORGANIZATION=<Github Org ID>
      - ACCESS_TOKEN=<GitHub Org Access Token>
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=github-actions-runner \
  --e ORGANIZATION=<Github Org ID> \
  --e ACCESS_TOKEN=<GitHub Org Access Token> \
  ghcr.io/binary-braids/github-actions-runner:latest
```

## Support
This image is provided as is and is a hobby project. With that being said, please see below on details for support.

### Issues

- Please submit a new [Issue](https://github.com/binary-braids/github-actions-runner/issues/new) if you encounter any bugs or issues

### Feature Requests

- You are welcome to submit a feature request but no timeline or guarantee will be provided regarding implentation thereof

### Updates

- The image will be updated from time to time based on fixes or new features
