FROM jenkins/inbound-agent:latest-alpine-jdk17

USER root

RUN apk update
RUN apk add --no-cache --update aws-cli \
                                git \
                                openssh \
                                sudo
RUN release= "curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'" && \
                wget https://releases.hashicorp.com/terraform/${release}/terraform_${release}_linux_amd64.zip && \
                unzip terraform_${release}_linux_amd64.zip && \
                mv terraform /usr/bin/terraform

USER jenkins
RUN mkdir -p /home/jenkins/.ssh/ && \
        touch /home/jenkins/.ssh/known_hosts && \
        chmod -R +r /home/jenkins/.ssh/ && \
        ssh-keyscan -H -t ssh-ed25519 github.com >> /home/jenkins/.ssh/known_hosts