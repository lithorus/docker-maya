FROM centos:centos7.2.1511
 
MAINTAINER lithorus@gmail.com
 
RUN yum update -y && yum install -y \
    nano \
    csh \
    libXp \
    libXmu \
    libXpm \
    libXi \
    libtiff \
    libXinerama \
    elfutils \
    gcc \
    gstreamer-plugins-base.x86_64 \
    gamin \
    git \
    mesa-utils \
    mesa-libGL-devel \
    tcsh \
    xorg-x11-server-Xorg \
    xorg-x11-server-Xvfb \
    wget && \
    yum groupinstall -y "X Window System" && \
    yum clean all

ENV LIBQUICKTIME_PLUGIN_DIR=/usr/autodesk/maya/lib
 
# Download and unpack distribution first, Docker's caching
# mechanism will ensure that this only happens once.
RUN wget https://edutrial.autodesk.com/NET18SWDLD/2018/MAYA/ESD/Autodesk_Maya_2018_EN_Linux_64bit.tgz -O maya.tgz && \
    mkdir /maya && tar -xvf maya.tgz -C /maya && \
    rm maya.tgz && \
    rpm -Uvh /maya/Maya*.rpm && \
    rm -r /maya

# Make mayapy the default Python
RUN echo alias hpython="\"/usr/autodesk/maya/bin/mayapy\"" >> ~/.bashrc && \
    echo alias hpip="\"mayapy -m pip\"" >> ~/.bashrc

# Setup environment
ENV MAYA_LOCATION=/usr/autodesk/maya/
ENV PATH=$MAYA_LOCATION/bin:$PATH

# Workaround for "Segmentation fault (core dumped)"
# See https://forums.autodesk.com/t5/maya-general/render-crash-on-linux/m-p/5608552/highlight/true
ENV MAYA_DISABLE_CIP=1

# Cleanup
WORKDIR /root
