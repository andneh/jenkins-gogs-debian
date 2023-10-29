FROM jenkins/jenkins:lts
USER root
RUN apt update && apt install -y htop python3
USER jenkins
# CMD ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]