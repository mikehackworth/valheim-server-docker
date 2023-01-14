ARG PARENT_IMAGE=debian:11.6-slim
FROM ${PARENT_IMAGE} as steamcmd
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common && \
    dpkg --add-architecture i386
RUN apt-get install -y --no-install-recommends \
    lib32gcc-s1 \
    steamcmd

FROM steamcmd as build
RUN steamcmd \
    +@sSteamCmdForcePlatformType linux \
    +force_install_dir /valheim-server \
    +login anonymous \
    +app_update 896660 validate \
    +quit

