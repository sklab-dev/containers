#!/usr/bin/env bash
# version=$(curl -sX GET "https://api.github.com/repos/projectmerge/merge/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)
version="1.0.3"
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
