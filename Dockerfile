FROM alpine AS base
RUN apk add curl

FROM base AS xbuild
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/resin-xbuild/v1.0.0/resin-xbuild1.0.0.tar.gz" \
  && echo "1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437  resin-xbuild1.0.0.tar.gz" | sha256sum -c - \
  && tar -xzf "resin-xbuild1.0.0.tar.gz" \
  && rm "resin-xbuild1.0.0.tar.gz" \
  && chmod +x resin-xbuild \
  && mv resin-xbuild /usr/bin \
  && ln -sf resin-xbuild /usr/bin/cross-build-start \
  && ln -sf resin-xbuild /usr/bin/cross-build-end \
  && install -D -t /out/usr/bin/ /usr/bin/resin-xbuild /usr/bin/cross-build-start /usr/bin/cross-build-end

FROM base AS qemu_arm
RUN curl -SLO "https://github.com/balena-io/qemu/releases/download/v4.0.0+balena2/qemu-4.0.0.balena2-arm.tar.gz" \
  && echo "ae0144b8b803ddb8620b7e6d5fd68e699a97e0e9c523d283ad54fcabc0e615f8  qemu-4.0.0.balena2-arm.tar.gz" | sha256sum -c - \
  && tar -xzf "qemu-4.0.0.balena2-arm.tar.gz" \
  && rm "qemu-4.0.0.balena2-arm.tar.gz" \
  && chmod +x qemu-4.0.0+balena2-arm/qemu-arm-static \
  && install -D -t /out/usr/bin/ qemu-4.0.0+balena2-arm/qemu-arm-static

FROM base AS qemu_aarch64
RUN curl -SLO "https://github.com/balena-io/qemu/releases/download/v4.0.0+balena2/qemu-4.0.0.balena2-aarch64.tar.gz" \
  && echo "e98eed19f680ae0b7e5937204040653c3312ae414f89eaccddeeb706934a63e4  qemu-4.0.0.balena2-aarch64.tar.gz" | sha256sum -c - \
  && tar -xzf "qemu-4.0.0.balena2-aarch64.tar.gz" \
  && rm "qemu-4.0.0.balena2-aarch64.tar.gz" \
  && chmod +x qemu-4.0.0+balena2-aarch64/qemu-aarch64-static \
  && install -D -t /out/usr/bin/ qemu-4.0.0+balena2-aarch64/qemu-aarch64-static

FROM scratch AS arm
COPY --from=xbuild /out/ /
LABEL io.balena.qemu.version="4.0.0+balena2-arm"
COPY --from=qemu_arm /out/ /

FROM scratch AS aarch64
COPY --from=xbuild /out/ /
LABEL io.balena.qemu.version="4.0.0+balena2-aarch64"
COPY --from=qemu_aarch64 /out/ /
