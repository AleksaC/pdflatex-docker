#!/usr/bin/env bash

set -eou pipefail

[[ "$(docker images -q latex:latest 2> /dev/null)" == "" ]] && docker build -t latex -<<- EOF
  FROM debian:buster-slim

  RUN apt-get update && apt-get install -y --no-install-recommends \
      texlive \
      texlive-latex-extra \
      texlive-fonts-extra \
    && rm -rf /var/lib/apt/lists/*

  WORKDIR /latex

  RUN chmod a+w .

  CMD pdflatex *.tex
EOF

DIR="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"

docker run --rm --user $(id -u):$(id -g) --mount type=bind,src=$DIR,target=/latex latex
