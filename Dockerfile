FROM steamcmd/steamcmd
RUN steamcmd \
    +@sSteamCmdForcePlatformType linux \
    +force_install_dir /valheim-server \
    +login anonymous \
    +app_update 896660 validate \
    +quit

FROM debian:11.6-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    # unity TLS dep
    ca-certificates \
    # crossplay deps
    libatomic1 \
    libc6 \
    libpulse-dev \
    && rm -rf /var/lib/apt/lists/*
RUN useradd --create-home valheim
COPY --from=0 /valheim-server /home/valheim/valheim-server
WORKDIR /home/valheim/valheim-server
USER valheim
RUN mkdir -p ~/.config/unity3d/IronGate/Valheim
# use SIGINT (ctrl-c) to stop gracefully
STOPSIGNAL SIGINT
# start with exec so that stop signal is received
# shell form entrypoint to allow env vars
ENTRYPOINT exec ./valheim_server.x86_64 \
    -name ${SERVER_NAME} \
    -password ${SERVER_PASSWORD} \
    -world ${WORLD_NAME} \
    -crossplay
