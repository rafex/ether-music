#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Este script debe ejecutarse como root (usa sudo)." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

ARCH="${ARCH:-x64}"
OS="${OS:-linux}"
IMAGE_TYPE="${IMAGE_TYPE:-jdk}"
JVM_IMPL="${JVM_IMPL:-hotspot}"
HEAP_SIZE="${HEAP_SIZE:-normal}"
PACKAGE_TYPE="${PACKAGE_TYPE:-jdk}"
FEATURE_VERSION="${FEATURE_VERSION:-25}"
INSTALL_BASE_DIR="${INSTALL_BASE_DIR:-/opt/java}"
DOWNLOAD_DIR="${DOWNLOAD_DIR:-/tmp/temurin-download}"
PROFILE_FILE="${PROFILE_FILE:-/etc/profile.d/java.sh}"
ALTERNATIVES_PRIORITY="${ALTERNATIVES_PRIORITY:-2525}"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Comando requerido no encontrado: $1" >&2
    exit 2
  }
}

echo "[1/8] Instalando dependencias necesarias..."
apt-get update -y
apt-get install -y --no-install-recommends curl ca-certificates jq tar coreutils

need_cmd curl
need_cmd jq
need_cmd sha256sum
need_cmd update-alternatives

echo "[2/8] Resolviendo URL de descarga para Temurin ${FEATURE_VERSION}..."
API_URL="https://api.adoptium.net/v3/assets/latest/${FEATURE_VERSION}/hotspot"
QUERY="architecture=${ARCH}&os=${OS}&image_type=${IMAGE_TYPE}&jvm_impl=${JVM_IMPL}&heap_size=${HEAP_SIZE}&vendor=eclipse"
JSON="$(curl -fsSL "${API_URL}?${QUERY}")"

TAR_URL="$(printf '%s' "${JSON}" | jq -r '.[0].binary.package.link')"
SHA_URL="$(printf '%s' "${JSON}" | jq -r '.[0].binary.package.checksum_link')"
PKG_NAME="$(printf '%s' "${JSON}" | jq -r '.[0].binary.package.name')"

if [[ -z "${TAR_URL}" || "${TAR_URL}" == "null" ]]; then
  echo "No se pudo resolver la URL del tar.gz de Temurin ${FEATURE_VERSION}." >&2
  exit 3
fi

if [[ -z "${SHA_URL}" || "${SHA_URL}" == "null" ]]; then
  echo "No se pudo resolver la URL del checksum de Temurin ${FEATURE_VERSION}." >&2
  exit 3
fi

mkdir -p "${DOWNLOAD_DIR}" "${INSTALL_BASE_DIR}"
TAR_PATH="${DOWNLOAD_DIR}/${PKG_NAME}"
SHA_PATH="${DOWNLOAD_DIR}/${PKG_NAME}.sha256.txt"

echo "[3/8] Descargando paquete y checksum..."
curl -fL "${TAR_URL}" -o "${TAR_PATH}"
curl -fL "${SHA_URL}" -o "${SHA_PATH}"

echo "[4/8] Validando checksum SHA-256..."
EXPECTED_SHA="$(awk '{print $1}' "${SHA_PATH}" | tr -d '\r\n')"
ACTUAL_SHA="$(sha256sum "${TAR_PATH}" | awk '{print $1}')"

if [[ -z "${EXPECTED_SHA}" || "${EXPECTED_SHA}" == "null" ]]; then
  echo "Checksum esperado vacío o inválido." >&2
  exit 4
fi

if [[ "${EXPECTED_SHA}" != "${ACTUAL_SHA}" ]]; then
  echo "Checksum inválido." >&2
  echo "Esperado: ${EXPECTED_SHA}" >&2
  echo "Actual:   ${ACTUAL_SHA}" >&2
  exit 4
fi

echo "Checksum correcto: ${ACTUAL_SHA}"

echo "[5/8] Instalando JDK en ${INSTALL_BASE_DIR}..."
TMP_EXTRACT_DIR="${DOWNLOAD_DIR}/extract"
rm -rf "${TMP_EXTRACT_DIR}"
mkdir -p "${TMP_EXTRACT_DIR}"
tar -xzf "${TAR_PATH}" -C "${TMP_EXTRACT_DIR}"

EXTRACTED_DIR="$(find "${TMP_EXTRACT_DIR}" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
if [[ -z "${EXTRACTED_DIR}" ]]; then
  echo "No se encontró directorio extraído del JDK." >&2
  exit 5
fi

FINAL_JAVA_HOME="${INSTALL_BASE_DIR}/temurin-${FEATURE_VERSION}"
rm -rf "${FINAL_JAVA_HOME}"
mv "${EXTRACTED_DIR}" "${FINAL_JAVA_HOME}"

echo "[6/8] Configurando variables de entorno globales en ${PROFILE_FILE}..."
cat > "${PROFILE_FILE}" <<EOF
export JAVA_HOME="${FINAL_JAVA_HOME}"
export PATH="\${JAVA_HOME}/bin:\${PATH}"
EOF
chmod 644 "${PROFILE_FILE}"

echo "[7/8] Registrando binarios en update-alternatives..."
JAVA_BIN_DIR="${FINAL_JAVA_HOME}/bin"
if [[ ! -d "${JAVA_BIN_DIR}" ]]; then
  echo "No existe directorio de binarios: ${JAVA_BIN_DIR}" >&2
  exit 6
fi

while IFS= read -r -d '' bin; do
  name="$(basename "${bin}")"
  update-alternatives --install "/usr/bin/${name}" "${name}" "${bin}" "${ALTERNATIVES_PRIORITY}"
  update-alternatives --set "${name}" "${bin}"
done < <(find "${JAVA_BIN_DIR}" -maxdepth 1 -type f -perm -u+x -print0)

echo "[8/8] Validando instalación..."
JAVA_VERSION_OUT="$(/usr/bin/java -version 2>&1 || true)"
JAVAC_VERSION_OUT="$(/usr/bin/javac -version 2>&1 || true)"

echo "JAVA_HOME=${FINAL_JAVA_HOME}"
echo "${JAVA_VERSION_OUT}"
echo "${JAVAC_VERSION_OUT}"

echo
echo "Instalación completada."
echo "Para sesión actual ejecuta: source ${PROFILE_FILE}"
