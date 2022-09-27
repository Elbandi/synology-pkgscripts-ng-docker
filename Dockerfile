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

ARG _DSM_VERSION=7.1
ARG _DSM_ARCH=v1000

RUN --security=insecure mkdir -p /synology && \
    cd /synology && \
    git clone -b "DSM${_DSM_VERSION}" https://github.com/SynologyOpenSource/pkgscripts-ng && \
    pkgscripts-ng/EnvDeploy -p $_DSM_ARCH -v $_DSM_VERSION && \
    rm -rf toolkit_tarballs

FROM scratch

ARG _DSM_VERSION=7.1
ARG _DSM_ARCH=v1000
ENV DSM_VERSION=${_DSM_VERSION}
ENV DSM_ARCH=${_DSM_ARCH}

copy --from=pkgscripts /synology/build_env/ds.${_DSM_ARCH}-${_DSM_VERSION}/ /
copy --from=pkgscripts /synology/pkgscripts-ng/ /pkgscripts-ng/
