FROM ubuntu:20.04
LABEL maintainer="Atesmaps <info@atesmaps.org>"
# Based on instructions from: https://wiki.openstreetmap.org/wiki/Mod_tile#Install_mod_tile_From_Source
# and ideas from https://github.com/jimmyrocks/osm-tiles-mapnik

ENV DEBIAN_FRONTEND=nonintercative
RUN apt update -qq && apt install -y --no-install-recommends \
    build-essential \
    curl \
  	fonts-noto-hinted \
    fonts-noto-unhinted \
    fonts-noto-cjk \
    fonts-hanazono \
    gdal-bin \
    git \
    gpg-agent \
    libproj-dev \
    mapnik-utils \
    npm \
    osm2pgsql \
    osmium-tool \
    postgresql-client \
    proj-data \
    python-is-python3 \
    python3-mapnik \
    python3-pip \
    python3-psycopg2 \
    python3-queuelib \
    python3-yaml \
    software-properties-common \
    ttf-unifont \
    unzip \
    wget \
    zip  \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g carto

COPY web_server/requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
