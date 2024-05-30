# syntax=docker/dockerfile:1
FROM ubuntu:jammy-20240212
LABEL maintainer="alchemine <djyoon0223@gmail.com>"

# ignore interaction
ARG DEBIAN_FRONTEND=noninteractive
ARG INSTALL_PYTHON=true
ARG INSTALL_POETRY=true
ARG INSTALL_JAVA=true

# copy context
COPY context/config     /opt/docker/context/config
COPY context/entrypoint /opt/docker/context/entrypoint
COPY context/utils      /opt/docker/context/utils

# use proxy
RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#http://mirror.kakao.com/ubuntu/#g' /etc/apt/sources.list && \
    sed -i 's#http://security.ubuntu.com/ubuntu/#http://mirror.kakao.com/ubuntu/#g' /etc/apt/sources.list

# install fundamental packages
RUN apt update && \
    xargs apt install -y < /opt/docker/context/utils/requirements.apt && \
    rm -rf /var/lib/apt/lists/*

# set fundamental configuration
RUN cat /opt/docker/context/config/account | chpasswd && \
    cat /opt/docker/context/config/sshd_config >> /etc/ssh/sshd_config && \
    cat /opt/docker/context/config/bashrc >> /root/.bashrc && \
    cat /opt/docker/context/config/vimrc >> /usr/share/vim/vimrc && \
    ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# install python
RUN if [ "$INSTALL_PYTHON" = "true" ]; then \
        /opt/docker/context/utils/install_python.sh; \
    fi

# install poetry
RUN if [ "$INSTALL_POETRY" = "true" ]; then \
        /opt/docker/context/utils/install_poetry.sh; \
    fi

# install java
RUN if [ "$INSTALL_JAVA" = "true" ]; then \
        /opt/docker/context/utils/install_java.sh; \
    fi  

# install extension packages
COPY context/extension /opt/docker/context/extension
RUN apt update && \
    xargs apt install -y < /opt/docker/context/extension/requirements.apt && \
    rm -rf /var/lib/apt/lists/*

# run entrypoint.sh
ENTRYPOINT [ "/opt/docker/context/entrypoint/entrypoint.sh" ]
CMD [ "/bin/bash" ]
