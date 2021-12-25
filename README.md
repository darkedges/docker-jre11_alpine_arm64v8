# docker-jre11_alpine_arm64v8

Could not find an `alpine`` version of https://hub.docker.com/r/arm64v8/eclipse-temurin/tags so built my own.

## Build

1. Start an `alpine` container

    ```bash
    docker run -it alpine sh
    ```

1. Issue the following commands in the container

    ```bash
    apk add alsa-lib-dev \
        autoconf \
        bash \
        cups-dev \
        curl \
        file \
        fontconfig-dev \
        g++ \
        gcc \
        git \
        libc-dev \
        libx11-dev \
        libxrandr-dev \
        libxrender-dev \
        libxt-dev \
        libxtst-dev \
        libxtst-dev \
        linux-headers \
        make \
        openjdk10 \
        openssl \
        perl \
        zip

    git clone https://github.com/adoptium/temurin-build.git
    cd temurin-build
    ./makejdk-any-platform.sh -J /usr/lib/jvm/java-10-openjdk --build-variant hotspot --configure-args --disable-warnings-as-errors --tag jdk-11.0.13+8_adopt --branch release jdk11u
    ```

1. Clone this repository

    ```bash
    git clone docker-jre11_alpine_arm64v8
    cd docker-jre11_alpine_arm64v8
    ```

1. Once completed keep the container running and issue the following command to extract `OpenJDK-jdk.tar.gz`

   ```bash
   CID=`docker ps | grep alpine | awk '{print $1}'`
   docker cp $CID:/temurin-build/workspace/target/OpenJDK-jdk.tar.gz .
   ```

1. Build Image

   ```bash
   docker build . -t arm64v8/eclipse-temurin:11.0.13_8-jre-alpine
   ```
