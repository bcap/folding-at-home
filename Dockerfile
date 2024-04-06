# base image

# FROM nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04 as base
FROM ubuntu:jammy as base

RUN apt-get update

# build image

FROM base as build

WORKDIR /app

RUN apt install -y wget

RUN wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb -O fahclient.deb

RUN dpkg -x fahclient.deb .

# release image

FROM base as release

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"
ENV DEBIAN_FRONTEND="noninteractive"
ENV MAJOR_VERSION=7.6

RUN apt install -y ocl-icd-opencl-dev
# RUN mkdir -p /etc/OpenCL/vendors
# RUN echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

RUN apt install -y ocl-icd-libopencl1

COPY --from=build /app/usr/bin/FAHClient /app/
COPY --from=build /app/usr/bin/FAHCoreWrapper /app/
COPY fah.sh /app/fah.sh
COPY config-template.xml /app/config-template.xml

# vars with empty values should be passed in. fah.sh will check for those
ENV FAH_USER=
ENV FAH_TEAM=
ENV FAH_PASSKEY=
ENV FAH_COMMAND_PASSWORD=

RUN mkdir /fah

EXPOSE 7396 36330

ENTRYPOINT ["/app/fah.sh"]
