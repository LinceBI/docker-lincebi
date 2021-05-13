#!/bin/sh

set -eu
export LC_ALL=C

# shellcheck disable=SC1091
. /usr/share/biserver/bin/set-utils.sh

for dir in "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_*/; do
	[ -d "${dir:?}" ] || continue

	# Move data directory
	( cd "${dir:?}"/data/*/; mv ./tomcat/webapps/pentaho/ ./tomcat/webapps/"${WEBAPP_PENTAHO_DIRNAME:?}"/; )

	# Replace some hardcoded values
	sed -ri 's|(<value>(tomcat/webapps/)?)pentaho(</value>)|\1'"${WEBAPP_PENTAHO_DIRNAME:?}"'\3|g' "${dir:?}"/endpoints/kettle/admin/installpack.kjb

	# Execute ETL
	/usr/share/biserver/bin/kitchen.sh \
		-level=Error \
		-file="${dir:?}"/endpoints/kettle/admin/installpack.kjb \
		-param=cpk.webapp.dir="${CATALINA_BASE:?}"/webapps/"${WEBAPP_PENTAHO_DIRNAME:?}"
done
