# syntax=docker/dockerfile:1-labs
from debian:bullseye AS pkgscripts
RUN apt-get update && apt-get install -y \
  tar \
  wget \
  curl \
  git \
  xz-utils \
  p7zip-full \
  python3 \
  && rm -rf /var/lib/apt/lists/*

ARG DSM_VERSION=7.1
ARG DSM_ARCH=v1000

RUN --security=insecure mkdir -p /synology && \
    cd /synology && \
    git clone -b "DSM${DSM_VERSION}" https://github.com/SynologyOpenSource/pkgscripts-ng && \
    pkgscripts-ng/EnvDeploy -p $DSM_ARCH -v $DSM_VERSION && \
    rm -rf toolkit_tarballs

FROM scratch

ARG DSM_VERSION=7.1
ARG DSM_ARCH=v1000

copy --from=pkgscripts /synology/build_env/ds.${DSM_ARCH}-${DSM_VERSION}/ /
copy --from=pkgscripts /synology/pkgscripts-ng/ /pkgscripts-ng/
