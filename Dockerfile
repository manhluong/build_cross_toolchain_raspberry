############################################################
# Dockerfile to build cross toolchain for ARMv6 with HF
#
############################################################
FROM debian:stretch
LABEL maintainer="Luong Bui"

RUN apt-get update \
 && apt-get -y install vim wget bzip2 git gcc g++ gperf bison flex texinfo help2man make libncurses5-dev python-dev patch gawk zip

RUN useradd --create-home -s /bin/bash user \
 && echo user:user | chpasswd \
 && adduser user sudo
WORKDIR /home/user
USER user

RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.bz2 && tar xvjf crosstool-ng-1.23.0.tar.bz2
WORKDIR crosstool-ng-1.23.0
RUN ./configure --prefix=/home/user/crosstool && make && make install
ENV PATH="${PATH}:/home/user/crosstool/bin"

RUN mkdir /home/user/armv6-rpi-linux-gnueabihf
WORKDIR /home/user/armv6-rpi-linux-gnueabihf
RUN ct-ng armv6-rpi-linux-gnueabi
RUN sed 's/^CT_ARCH_FLOAT_AUTO/# CT_ARCH_FLOAT_AUTO/' -i .config \
 && sed 's/^# CT_ARCH_FLOAT_HW is not set/CT_ARCH_FLOAT_HW=y/' -i .config \
 && sed 's/^CT_ARCH_FLOAT="auto"/CT_ARCH_FLOAT="hard"/' -i .config \
 && echo 'CT_ARCH_ARM_TUPLE_USE_EABIHF=y' >> .config \
 && sed 's/^# CT_CC_GCC_LIBGOMP is not set/CT_CC_GCC_LIBGOMP=y/' -i .config \
 && sed 's/CT_LOG_PROGRESS_BAR/# CT_LOG_PROGRESS_BAR/' -i .config
RUN ct-ng build
RUN rm -rf /home/user/armv6-rpi-linux-gnueabihf

USER root
WORKDIR /home/user/x-tools
RUN zip -r /armv6-rpi-linux-gnueabihf.zip armv6-rpi-linux-gnueabihf/

