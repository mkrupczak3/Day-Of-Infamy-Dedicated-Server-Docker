# escape=`
FROM lacledeslan/steamcmd:linux as doi-builder


ARG contentServer=false
ARG SKIP_STEAMCMD=false

# Copy in local cache files (if any)
COPY ./.steamcmd-cache/linux /output

# Download CSGO via SteamCMD
RUN if [ "$SKIP_STEAMCMD" = true ] ; then `
        echo "\n\nSkipping SteamCMD install -- using only contents from steamcmd-cache\n\n"; `
    else `
        echo "\n\nDownloading Day of Infamy via SteamCMD"; `
        mkdir --parents /output; `
        /app/steamcmd.sh +login anonymous +force_install_dir /output +app_update 462310 validate +quit; `
    fi;

RUN if [ "$contentServer" = false ] ; then `
        echo "\n\nSkipping custom LL content\n\n"; `
    else `
        echo "\nDownloading custom LL content from $contentServer" &&`
                mkdir --parents /tmp/maps/ /output &&`
                cd /tmp/maps/ &&`
                wget -rkpN -l 1 -nH  --no-verbose --cut-dirs=3 -R "*.htm*" -e robots=off "http://"$contentServer"/fastDownloads/csgo/maps/" &&`
            echo "Decompressing files" &&`
                bzip2 --decompress /tmp/maps/*.bz2 &&`
            echo "Moving uncompressed files to destination" &&`
                mkdir --parents /output/csgo/maps/ &&`
                mv --no-clobber *.bsp *.nav /output/csgo/maps/; `
    fi;

#=======================================================================`
FROM debian:stable-slim

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

HEALTHCHECK NONE

RUN dpkg --add-architecture i386 &&`
    apt-get update && apt-get install -y `
        ca-certificates lib32gcc1 libstdc++6 libstdc++6:i386 locales locales-all tmux &&`
    apt-get clean &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

LABEL maintainer="mkrupczak <t3l3tubie@gmail.com>" `
      com.lacledeslan.build-node=$BUILDNODE `
      org.label-schema.schema-version="1.0" `
      org.label-schema.url="https://github.com/LacledesLAN/README.1ST" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.vendor="Matts Bytes" `
      org.label-schema.description="Day of Infamy Dedicated Server" `
      org.label-schema.vcs-url="@TODO REPLACE ME WITH GITHUB URL"

# Set up Enviornment
RUN useradd --home /app --gid root --system DOI &&`
    mkdir -p /app/ll-tests &&`
    chown DOI:root -R /app;

# `RUN true` lines are work around for https://github.com/moby/moby/issues/36573
COPY --chown=DOI:root --from=csgo-builder /output /app
# this angers me (Matt)
RUN true

COPY --chown=DOI:root ./dist/linux/ll-tests /app/ll-tests
RUN chmod +x /app/ll-tests/*.sh;

USER DOI

RUN echo $'\n\nLinking steamclient.so to prevent srcds_run errors' &&`
        mkdir --parents /app/.steam/sdk32 &&`
        ln -s /app/bin/steamclient.so /app/.steam/sdk32/steamclient.so;

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
