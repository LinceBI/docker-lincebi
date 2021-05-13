#!/bin/sh

set -eu
export LC_ALL=C

# shellcheck disable=SC1091
. /usr/share/biserver/bin/set-utils.sh

for dir in "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_*/; do
	[ -d "${dir:?}" ] || continue

	if [ "${WEBAPP_PENTAHO_DIRNAME:?}" != 'pentaho' ]; then
		# Move webapp directory
		data_webapps_dir=$(printf -- '%s' "${dir:?}"/data/*/tomcat/webapps/)
		mv "${data_webapps_dir:?}"/pentaho/ "${data_webapps_dir:?}"/"${WEBAPP_PENTAHO_DIRNAME:?}"/

		# Replace some hardcoded values
		sed -ri 's|(<value>(tomcat/webapps/)?)pentaho(</value>)|\1'"${WEBAPP_PENTAHO_DIRNAME:?}"'\3|g' "${dir:?}"/endpoints/kettle/admin/installpack.kjb
	fi

	# Execute ETL
	/usr/share/biserver/bin/kitchen.sh \
		-level=Error \
		-file="${dir:?}"/endpoints/kettle/admin/installpack.kjb \
		-param=cpk.webapp.dir="${CATALINA_BASE:?}"/webapps/"${WEBAPP_PENTAHO_DIRNAME:?}"
done
