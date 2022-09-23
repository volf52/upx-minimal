FROM radial/busyboxplus:curl as getUpx

WORKDIR /

RUN curl -sSL $(curl -s "https://api.github.com/repos/upx/upx/releases/latest" \
  | grep browser_download_url | grep amd64 | cut -d '"' -f 4) -o /upx.tar.xz

FROM busybox:latest as extractor

COPY --from=getUpx /upx.tar.xz .

RUN tar -xf ./upx.tar.xz \
  && cd upx-*-amd64_linux \
  && mv ./upx /bin/upx

FROM scratch
COPY --from=extractor /bin/upx /bin/upx

ENTRYPOINT ["/bin/upx"]
