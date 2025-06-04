FROM debian:12-slim

ENV DEBIAN_FRONTEND "noninteractive"
ENV STEAM_APP_ID "1829350"
ENV HOME "/opt/steam"
ENV VRISING_PATH "/opt/steam/vrising"
ENV WINEPREFIX "/opt/steam/.vrising_prefix"

ENV GAME_PORT "27015"
ENV QUERY_PORT "27016"
ENV BIND_ADDRESS "0.0.0.0"
ENV HIDE_IP "true"
ENV LOWER_FPS_EMPTY "true"
ENV SECURE "true"
ENV DESCRIPTION "A VRISING SERVER"
ENV EOS_LIST "true"
ENV STEAM_LIST "false"
ENV SAVE_NAME "vrising_world"

RUN sed -i 's#^Components: .*#Components: main non-free contrib#g' /etc/apt/sources.list.d/debian.sources \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        procps \
        ca-certificates \
        winbind \
        cabextract \
        dbus \
        libfreetype6 \
        curl \
        wget \
        locales \
        lib32gcc-s1 \
        steamcmd \
        xvfb \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
    && apt-get update \
    && apt-get install --install-recommends -y winehq-stable \
    && wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/local/bin/winetricks \  
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd \
    && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && rm -f /etc/machine-id \
    && dbus-uuidgen --ensure=/etc/machine-id \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoremove -y 

COPY entrypoint.sh /opt/steam/entrypoint.sh
COPY winetricks.sh /opt/steam/winetricks.sh

RUN mkdir -p "$VRISING_PATH" \
    && mkdir -p "${VRISING_PATH}/save-data" \
    && mkdir -p "${VRISING_PATH}/logs" \
    && steamcmd +quit \
    && /opt/steam/winetricks.sh

WORKDIR /opt/steam

CMD ["/opt/steam/entrypoint.sh"]
