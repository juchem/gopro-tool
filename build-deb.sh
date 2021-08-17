#!/bin/bash -e
SRC_DIR="$(git rev-parse --show-toplevel)"
PACKAGE_NAME="gopro-tool"
PACKAGE_VERSION="1.0"
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
  sed \
    -e "s/INSTALLED_SIZE/${installed_size}/g" \
    -e "s/PACKAGE_VERSION/${PACKAGE_VERSION}/g" \
    "${CURRENT_SRC_DIR}/${file}" \
    > "${CURRENT_OUT_DIR}/${file}"
done

dpkg-deb --build "${OUT_DIR}"

# apt repo
REPO_DIR="${BUILD_DIR}/apt-repo/debian"
mkdir -p "${REPO_DIR}"
cp "${BUILD_DIR}/${PACKAGE_NAME}.deb" "${REPO_DIR}/${PACKAGE_NAME}-${PACKAGE_VERSION}_all.deb"
dpkg-scanpackages "${REPO_DIR}" | gzip -c9 > "${REPO_DIR}/Packages.gz"
