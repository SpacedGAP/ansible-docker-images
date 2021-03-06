#!/bin/bash
# Autogenerates Dockerfiles based on configuration
set -o errexit
set -o nounset

# Script

REL_HERE="$(dirname "${BASH_SOURCE}")"
HERE=$(cd "${REL_HERE}"; pwd)

AUTOGEN_TARGET=$(cd "${HERE}/../autogen"; pwd)

pushd "${HERE}" >/dev/null

for dir in "platform/"*; do
  versions="$(cat "${dir}/VERSIONS")"

  platform="$(basename "${dir}")"
  for version in ${versions}; do
    source_image="${platform}:${version}"
    ansible_versions="$(cat "${HERE}/VERSIONS")"
    for ansible_version in ${ansible_versions}; do
      # Config
      ANSIBLE_VERSION="${ansible_version}"

      dockerfile="${AUTOGEN_TARGET}/${platform}-${version}-${ansible_version}/Dockerfile"

      echo "Preparing Dockerfile for ${source_image} in ${dockerfile}"
      mkdir -p "$(dirname "${dockerfile}")"

      cp "${HERE}/Dockerfile.in" "${dockerfile}"

      perl -pe "s/__SOURCE_IMAGE__/'${source_image}'/ge" -i "${dockerfile}"
      perl -pe "s/__ANSIBLE_VERSION__/'${ANSIBLE_VERSION}'/ge" -i "${dockerfile}"

      pushd "${HERE}/platform/${platform}" >/dev/null
      perl -pe 's/__ANSIBLE_INSTALL_APP__/`cat install-app`/ge' -i "${dockerfile}"
      perl -pe 's/__ANSIBLE_INSTALL_DEPS__/`cat install-deps`/ge' -i "${dockerfile}"
      perl -pe 's/__ANSIBLE_CLEANUP_DEPS__/`cat cleanup-deps`/ge' -i "${dockerfile}"
      popd >/dev/null

      perl -n -e 'print if /\S/' -i "${dockerfile}"
    done
  done
done

popd >/dev/null
