FROM ubuntu:latest
MAINTAINER martino.trevisan@polito.it

# Install docker
RUN apt-get update
RUN apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    sudo
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
RUN apt-get update
RUN apt-get -y install docker-ce
#RUN service docker start

# Install ssh server
RUN apt-get -y install openssh-server
RUN awk '{if($1 == "PermitRootLogin")$2="yes"; print }' /etc/ssh/sshd_config > /tmp/sshd_config && \
    cp /tmp/sshd_config /etc/ssh/sshd_config
RUN echo "root:toor" | chpasswd

# Install some utils
RUN apt-get -y install iputils-ping net-tools nano

# Add group docker
#RUN groupadd docker

# Add files
RUN echo "/opt/docker_shell.sh" >> /etc/shells
COPY files/docker_shell.sh /opt
COPY files/start_daemons.sh /opt
COPY files/adduser_docker /usr/local/bin
RUN chmod 777 /opt/docker_shell.sh && chmod 777 /usr/local/bin/adduser_docker && chmod 777 opt/start_daemons.sh

# Entrypoint
CMD [ "/opt/start_daemons.sh" ]




