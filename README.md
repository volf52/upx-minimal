# Minimal Image for UPX

Use it to compress binaries easily.

## Usage

```bash
docker run --rm -w $PWD -v $PWD:$PWD volf52/upx-minimal:1.0 --best --lzma -o app.out ./app
```


Or in a docker image (multistage build)

```dockerfile
# ... other build steps

FROM volf52/upx-minimal:1.0 as upx-src
FROM alpine:latest as compresser

COPY --from=upx-src /bin/upx .
COPY --from=build-step /app .

RUN ./upx --best --lzma -o app.out app

# Use the binary in other stages
FROM base as prod

COPY --from=compresser /app.out ./app
```
