FROM ubuntu:22.04@sha256:340d9b015b194dc6e2a13938944e0d016e57b9679963fdeb9ce021daac430221

# renovate: datasource=github-releases depName=github-actions-runner packageName=actions/runner
ENV RUNNER_VERSION=2.317.0

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y && useradd -m docker
RUN apt install -y --no-install-recommends \
    curl jq build-essential unzip libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip zip

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER docker

ENTRYPOINT ["./start.sh"]