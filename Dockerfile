FROM ubuntu:bionic

ARG bitcoinVersion=v23.0

LABEL maintainer="Florent Dufour <florent+github@dufour.xyz>"
LABEL description="Bitcoin full node on docker, built from source."
LABEL version="23.0"

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Paris

RUN --mount=type=cache,target=/var/cache/apt apt-get update -y \
  # Install tools
  && apt-get install --no-install-recommends -y ca-certificates locales git wget vim gcc+-8 \
  # Install build dependencies
  build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 \
  # Install libraries
  libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev \
  # Clean up
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /root/.cache \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Checkout bitcoin source
WORKDIR /tmp
RUN git clone --verbose -b "${bitcoinVersion}" --depth=1 "https://github.com/bitcoin/bitcoin.git" bitcoin