# xbuild

sets up any base image to work like: https://www.balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/

```
FROM alpine@sha256:3b3f647d2d99cac772ed64c4791e5d9b750dd5fe0b25db653ec4976f7b72837c # alpine:3.12 for linux/arm64
COPY --from=robertgzr/xbuild:aarch64 / /

RUN [ "cross-build-start" ]
RUN uname -a
RUN [ "cross-build-end" ]
```
