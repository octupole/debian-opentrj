# ------------------------------------------------------------------------------
# build stage
# Uses https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.bz2
# ------------------------------------------------------------------------------
FROM octupole/debian-openmpi:latest as base-openmpi 
FROM debian:stretch

COPY --from=base-openmpi /usr/local /usr/local

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/octupole/debian-opentrj" \
      org.label-schema.version=$VERSION

RUN set -x \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get  install python3 python3-dev tzdata cmake g++ tar make \
     fftw3-dev wget -y \
  && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && cd /tmp \
  && wget https://github.com/octupole/openTRJ/archive/v0.5.beta8.tar.gz \
  && tar xvfz "v0.5.beta8.tar.gz" \
  && cd openTRJ-0.5.beta8 \
  && mkdir build\
  && cd build\
  && cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. \
  && make -j \
  && make install


