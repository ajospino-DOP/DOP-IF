FROM jenkins/inbound-agent:latest-alpine-jdk17

USER root

RUN apk update
RUN apk add --no-cache --update aws-cli \
                                git \
                                openssh \
                                sudo
RUN wget https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip && \
                unzip terraform_1.4.6_linux_amd64.zip && \
                mv terraform /usr/bin/terraform

USER jenkins
RUN mkdir -p /home/jenkins/.ssh/ && \
        touch /home/jenkins/.ssh/known_hosts && \
        chmod -R +r /home/jenkins/.ssh/ && \
        ssh-keyscan -H -t ssh-ed25519 github.com >> /home/jenkins/.ssh/known_hosts