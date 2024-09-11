#!/bin/sh

set -eu
export LC_ALL=C

# shellcheck disable=SC1091
. /usr/share/biserver/bin/set-utils.sh

KARAF_DIR="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/karaf/

if [ -e "${KARAF_DIR:?}"/etc/profile.cfg ]; then
	sed -ri \
		-e 's|^\s*feature\.pentaho-marketplace\s*=.+$||' \
		-e 's|^\s*repository\.mvn\\\:org\.pentaho/pentaho-marketplace/[^/]+/xml/features\s*=.+||' \
		"${KARAF_DIR:?}"/etc/profile.cfg
fi

if [ -e "${KARAF_DIR:?}"/etc/org.apache.karaf.features.cfg ]; then
	sed -ri \
		-e 's|pentaho-marketplace,||' \
		-e 's|mvn:org\.pentaho/pentaho-marketplace/[^/]+/xml/features,||' \
		"${KARAF_DIR:?}"/etc/org.apache.karaf.features.cfg
fi

rm -rf "${KARAF_DIR:?}"/system/org/pentaho/pentaho-marketplace
rm -rf "${KARAF_DIR:?}"/system/org/pentaho/pentaho-marketplace-ba
