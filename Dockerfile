# Build osslsigncode in a build stage
FROM debian:stable AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        ca-certificates \
        curl \
        gcc \
        libcurl4-openssl-dev \
        libssl-dev \
        make \
        netbase \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

ENV O_REL=2.1 O_VER=2.1.0
RUN cd /tmp \
    && curl -OL https://github.com/mtrojnar/osslsigncode/releases/download/${O_REL}/osslsigncode-${O_VER}.tar.gz \
    && tar zxf osslsigncode-${O_VER}.tar.gz \
    && cd osslsigncode-${O_VER} \
    && ./configure \
    && make install

# Now create the final image
FROM debian:stable-slim
MAINTAINER Brian Bassett <bbassett1276@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libcurl4 \
        libssl1.1 \
        netbase \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bin /usr/local/bin
ENTRYPOINT ["/usr/local/bin/osslsigncode"]

