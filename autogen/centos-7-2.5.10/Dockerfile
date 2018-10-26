FROM centos:7
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm
RUN ANSIBLE_VERSION="2.5.10" && \
    echo "Installing build dependencies" && \
    yum -y update; \
yum clean all; \
# Install systemd -- See https://hub.docker.com/_/centos/
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*; \
\
yum makecache fast \
 && yum -y install deltarpm epel-release initscripts \
 && yum -y update \
 && yum -y install \
      sudo \
      which \
      python-pip \
 && \
    echo "Installing Ansible" && \
    pip install ansible==${ANSIBLE_VERSION} && \
# Install Ansible inventory file.
mkdir -p /etc/ansible && \
echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts && \
    echo "Cleaning up" && \
    yum clean all && \
    echo "Done"
