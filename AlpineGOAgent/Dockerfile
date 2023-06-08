#Jenkins-Agent Dockerfile ---> Only for updating and pushing to ECR
FROM jenkins/inbound-agent:latest-alpine-jdk17

COPY --from=golang:alpine /usr/local/go/ /usr/local/go/

ARG DB_URI
ENV MONGODB_URI=${DB_URI}

ENV PATH="/usr/local/go/bin:${PATH}"

USER root

RUN chmod +x /usr/local/go/

RUN apk update
RUN apk add --no-cache --update aws-cli \
                docker \
                git \
                openssh

RUN adduser jenkins docker

USER jenkins
RUN mkdir -p /home/jenkins/.ssh/ && \
        touch /home/jenkins/.ssh/known_hosts && \
        chmod -R +r /home/jenkins/.ssh/ && \
        ssh-keyscan -H -t ssh-ed25519 github.com >> /home/jenkins/.ssh/known_hosts
