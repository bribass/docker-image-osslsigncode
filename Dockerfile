# Build osslsigncode in a build stage
FROM debian:jessie AS build

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

ENV O_VER=1.7.1
RUN cd /tmp \
    && curl -OL https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-${O_VER}.tar.gz \
    && tar zxf osslsigncode-${O_VER}.tar.gz \
    && cd osslsigncode-${O_VER} \
    && ./configure \
    && make install

# Now create the final image
FROM debian:jessie-slim
MAINTAINER Brian Bassett <bbassett1276@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libcurl3 \
        libssl1.0.0 \
        netbase \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bin /usr/local/bin
ENTRYPOINT ["/usr/local/bin/osslsigncode"]

