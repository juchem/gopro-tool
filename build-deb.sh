#!/bin/bash -e
SRC_DIR="$(git rev-parse --show-toplevel)"
PACKAGE_NAME="gopro-tool"
BUILD_DIR="${SRC_DIR}/out"
OUT_DIR="${BUILD_DIR}/${PACKAGE_NAME}"

[ ! -d "${BUILD_DIR}" ] || rm -rf "${BUILD_DIR}"

# usr/bin
CURRENT_SRC_DIR="${SRC_DIR}"
CURRENT_OUT_DIR="${OUT_DIR}/usr/bin"
mkdir -p "${CURRENT_OUT_DIR}"
for file in "gopro-tool"; do
  install --mode=755 "${CURRENT_SRC_DIR}/${file}" "${CURRENT_OUT_DIR}/${file}"
done

installed_size="$(du -sb "${OUT_DIR}" | awk '{print $1}')"

# DEBIAN
CURRENT_SRC_DIR="${SRC_DIR}/DEBIAN"
CURRENT_OUT_DIR="${OUT_DIR}/DEBIAN"
mkdir -p "${CURRENT_OUT_DIR}"
for file in "control"; do
  sed "s/INSTALLED_SIZE/${installed_size}/g" \
    "${CURRENT_SRC_DIR}/${file}" \
    > "${CURRENT_OUT_DIR}/${file}"
done

dpkg-deb --build "${OUT_DIR}"
