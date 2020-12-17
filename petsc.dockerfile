# Docker file for a slim Ubuntu-based Python3 image

FROM ubuntu:20.04

ENV TZ=Europe/Istanbul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

RUN apt-get update \
  && apt-get install -y \
    git \
    wget \
    make \
    gcc \
    gfortran \
    mpich \
    pkg-config


ENV SWDIR=/opt

WORKDIR ${SWDIR}
RUN git clone https://gitlab.com/petsc/petsc.git

ARG PYTHON_VERSION_TAG=3.8.3
ARG LINK_PYTHON_TO_PYTHON3=1

COPY install_python.sh install_python.sh
RUN bash install_python.sh ${PYTHON_VERSION_TAG} ${LINK_PYTHON_TO_PYTHON3} && \
    rm -r install_python.sh Python-${PYTHON_VERSION_TAG}

#RUN add-apt-repository ppa:deadsnakes/ppa
#RUN apt install python3.8 -y &&\
    #ln -s /usr/bin/pip3 /usr/bin/pip &&\
    #ln -s /usr/bin/python3.8 /usr/bin/python 

#ENV PETSC_VERSION=3.7.2 \
    #SLEPC_VERSION=3.7.1 \
    #ARCH=arch-linux2-c-debug \
    #SWDIR=/opt

#ENV PETSC_DIR=${SWDIR}/petsc-${PETSC_VERSION} \
    #SLEPC_DIR=${SWDIR}/slepc-${SLEPC_VERSION} \
    #PETSC_ARCH=${ARCH} \
    #SLEPC_ARCH=${ARCH}

#ENV PETSC_LIB=${PETSC_DIR}/${PETSC_ARCH}/lib/ \
    #SLEPC_LIB=${SLEPC_DIR}/${SLEPC_ARCH}/lib/

#ENV LD_LIBRARY_PATH=${PETSC_LIB}:${SLEPC_LIB}:${LD_LIBRARY_PATH}


 ## install everything
#COPY setup.sh ${SWDIR}/
#WORKDIR ${SWDIR}
#RUN chmod +x ./setup.sh
#RUN ./setup.sh ${PETSC_VERSION} ${SLEPC_VERSION} ${ARCH} ${SWDIR}

##RUN apt-get update \
  ##&& apt-get install -y \
    ##python3-pip\
    ##python3-dev \
    ##python3-mpi4py \
    ##python3-numpy \
    ##wget \
  ##&& cd /usr/local/bin \
  ##&& ln -s /usr/bin/python3 python \
  ##&& pip3 install --upgrade pip

##FROM phusion/baseimage:0.9.18

##ENV PETSC_VERSION=3.7.2 \
    ##SLEPC_VERSION=3.7.1 \
    ##ARCH=arch-linux2-c-debug \
    ##SWDIR=/opt

##ENV PETSC_DIR=${SWDIR}/petsc-${PETSC_VERSION} \
    ##SLEPC_DIR=${SWDIR}/slepc-${SLEPC_VERSION} \
    ##PETSC_ARCH=${ARCH} \
    ##SLEPC_ARCH=${ARCH}

##ENV PETSC_LIB=${PETSC_DIR}/${PETSC_ARCH}/lib/ \
    ##SLEPC_LIB=${SLEPC_DIR}/${SLEPC_ARCH}/lib/

##ENV LD_LIBRARY_PATH=${PETSC_LIB}:${SLEPC_LIB}:${LD_LIBRARY_PATH}


## # install everything

##COPY setup.sh ${SWDIR}/
##WORKDIR ${SWDIR}
##RUN chmod +x ./setup.sh
##RUN ./setup.sh ${PETSC_VERSION} ${SLEPC_VERSION} ${ARCH} ${SWDIR}
##RUN wget https://gitlab.com/petsc/petsc4py/-/archive/3.13.0/petsc4py-3.13.0.tar.gz

##ENV TZ=Europe/Istanbul
##RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    ##&& echo $TZ > /etc/timezone

##RUN add-apt-repository ppa:deadsnakes/ppa \
  ##&& apt-get update \
  ##&& apt-get install -y \
    ##python3.5 \
    ##python3-pip\
    ##python3-dev \
    ##python3-mpi4py \
    ##python3-numpy \
    ##wget \
  ##&& cd /usr/local/bin \
  ##&& ln -s /usr/bin/python3 python \
  ##&& pip3 install --upgrade pip

##WORKDIR /usr/src/app
##COPY . .
