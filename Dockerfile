# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary tools
RUN apt-get update --no-install-recommends && \
    apt-get install -y --no-install-recommends\
    autoconf-archive \
    libpthread-stubs0-dev \
    dos2unix \
    autoconf \
    automake \
    libtool \
    gcc \
    g++ \
    make \
    cmake \
    gfortran \
    libexpat-dev

COPY . /app
WORKDIR /app
RUN mkdir -p /app/test
RUN mkdir -p /app/packages/nefis/src/libs
RUN mkdir -p /app/packages/nefis/src_so/libs

RUN chmod +x ./scripts_lgpl/linux/update_version.sh
RUN chmod +x autogen.sh configure.ac build.sh
RUN dos2unix autogen.sh
# RUN autoreconf -i
# RUN ./build.sh
RUN bash -c "./build.sh" || true

WORKDIR /app/packages/nefis/src/.libs
RUN find . -name "libNefis.a"
# RUN g++ -shared -o libNefis.so -Wl,--whole-archive libNefis.a -Wl,--no-whole-archive -lexpat -lstdc++
# RUN gcc -shared -o libNefis.so -Wl,--whole-archive libNefis.a -Wl,--no-whole-archive
RUN gcc -shared -o libNefis.so -Wl,--no-undefined -Wl,--whole-archive libNefis.a -Wl,--no-whole-archive
