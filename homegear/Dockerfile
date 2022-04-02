#ARG BUILD_FROM=debian:bullseye
ARG BUILD_FROM=homeassistant/base-raspbian:bullseye
FROM ${BUILD_FROM}

USER root

# Homegear installation - https://homegear.eu/downloads.html
RUN \
echo "[INFO] Install Homegear" && \
apt update && \
apt install -y apt-transport-https curl gpg && \
curl -fsSL https://apt.homegear.eu/Release.key | gpg --dearmor -o /usr/share/keyrings/homegear-archive-keyring.gpg && \
echo 'deb [signed-by=/usr/share/keyrings/homegear-archive-keyring.gpg] https://apt.homegear.eu/debian/bullseye/homegear/stable/ bullseye main' > /etc/apt/sources.list.d/homegear.list && \
apt update && \
apt install -y homegear-gateway && \
\
rm /var/lib/homegear/homegear_updated

COPY main.conf /main.conf
COPY homematicbidcos.conf /homematicbidcos.conf
COPY gateway.conf /gateway.conf
COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/bin/bash", "-c", "/run.sh"]


# Labels
LABEL \
    io.hass.name="Debian Base" \
    io.hass.description="Dabian Base Add-On" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="https://github.com/rcreate" \
    org.label-schema.description="Debian Base Add-On" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Debian Base" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/rcreate/hassio-debian-base" \
    org.label-schema.usage="https://github.com/rcreate/hassio-dabian-base" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/rcreate/hassio-debian-base" \
    org.label-schema.vendor="https://github.com/rcreate"

