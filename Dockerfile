FROM radial/busyboxplus:curl as getUpx

WORKDIR /bench

ARG VERSION
# RUN curl -sSL $(curl -s "https://api.github.com/repos/upx/upx/releases/latest" \
#   | grep browser_download_url | grep amd64 | cut -d '"' -f 4) -o /upx.tar.xz
RUN curl -sSL "https://github.com/upx/upx/releases/download/v$VERSION/upx-$VERSION-amd64_linux.tar.xz" -o "/bench/upx-$VERSION.tar.xz"

FROM busybox:1.35.0 as extractor

WORKDIR /bench

ARG VERSION
COPY --from=getUpx /bench/upx-$VERSION.tar.xz ./upx.tar.xz

RUN tar -xf /bench/upx.tar.xz \
  && cd upx-*-amd64_linux \
  && mv ./upx /bench/upx

FROM scratch
COPY --from=extractor /bench/upx /bin/upx

ENTRYPOINT ["/bin/upx"]
