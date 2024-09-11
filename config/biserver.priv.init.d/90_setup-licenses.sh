#!/bin/sh

set -eu
export LC_ALL=C

# shellcheck disable=SC1091
. /usr/share/biserver/bin/set-utils.sh

STTOOLS_TOKEN=$(getVar STTOOLS_TOKEN)

STAGILE_PLUGIN_DIR="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/stagile/
if [ -e "${STAGILE_PLUGIN_DIR:?}" ]; then
	STAGILE_PROPERTIES_FILE="${STAGILE_PLUGIN_DIR:?}"/stagile.properties
	STAGILE_LICENSE_FILE="${STAGILE_PLUGIN_DIR:?}"/STAgile.key
	STAGILE_LICENSE=$(getVar STAGILE_LICENSE)

	if [ -n "${STTOOLS_TOKEN-}" ]; then
		if [ -e "${STAGILE_PROPERTIES_FILE:?}" ]; then
			sed -i "s|^\s*\(stagile\.token\)\s*=.*$|\1=${STTOOLS_TOKEN-}|" "${STAGILE_PROPERTIES_FILE:?}"
		else
			printf '%s\n' "stagile.token=${STTOOLS_TOKEN:?}" > "${STAGILE_PROPERTIES_FILE:?}"
		fi
	fi

	if [ -n "${STAGILE_LICENSE-}" ]; then
		printf '%s\n' "${STAGILE_LICENSE:?}" > "${STAGILE_LICENSE_FILE:?}"
	fi
fi

STDASHBOARD_PLUGIN_DIR="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/stdashboard/
if [ -e "${STDASHBOARD_PLUGIN_DIR:?}" ]; then
	STDASHBOARD_PROPERTIES_FILE="${STDASHBOARD_PLUGIN_DIR:?}"/stdashboard.properties
	STDASHBOARD_LICENSE_FILE="${STDASHBOARD_PLUGIN_DIR:?}"/STDashboard.key
	STDASHBOARD_LICENSE=$(getVar STDASHBOARD_LICENSE)

	if [ -n "${STTOOLS_TOKEN-}" ]; then
		if [ -e "${STDASHBOARD_PROPERTIES_FILE:?}" ]; then
			sed -i "s|^\s*\(stdashboard\.token\)\s*=.*$|\1=${STTOOLS_TOKEN-}|" "${STDASHBOARD_PROPERTIES_FILE:?}"
		else
			printf '%s\n' "stdashboard.token=${STTOOLS_TOKEN:?}" > "${STDASHBOARD_PROPERTIES_FILE:?}"
		fi
	fi

	if [ -n "${STDASHBOARD_LICENSE-}" ]; then
		printf '%s\n' "${STDASHBOARD_LICENSE:?}" > "${STDASHBOARD_LICENSE_FILE:?}"
	fi
fi

STMETADATAWIZARD_PLUGIN_DIR="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/stmetadatawizard/
if [ -e "${STMETADATAWIZARD_PLUGIN_DIR:?}" ]; then
	STMETADATAWIZARD_PROPERTIES_FILE="${STMETADATAWIZARD_PLUGIN_DIR:?}"/stmetadatawizard.properties
	STMETADATAWIZARD_LICENSE_FILE="${STMETADATAWIZARD_PLUGIN_DIR:?}"/STMetadataWizard.key
	STMETADATAWIZARD_LICENSE=$(getVar STMETADATAWIZARD_LICENSE)

	if [ -n "${STTOOLS_TOKEN-}" ]; then
		if [ -e "${STMETADATAWIZARD_PROPERTIES_FILE:?}" ]; then
			sed -i "s|^\s*\(stmetadatawizard\.token\)\s*=.*$|\1=${STTOOLS_TOKEN-}|" "${STMETADATAWIZARD_PROPERTIES_FILE:?}"
		else
			printf '%s\n' "stmetadatawizard.token=${STTOOLS_TOKEN:?}" > "${STMETADATAWIZARD_PROPERTIES_FILE:?}"
		fi
	fi

	if [ -n "${STMETADATAWIZARD_LICENSE-}" ]; then
		printf '%s\n' "${STMETADATAWIZARD_LICENSE:?}" > "${STMETADATAWIZARD_LICENSE_FILE:?}"
	fi
fi

STPANELS_PLUGIN_DIR="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/stpanels/
if [ -e "${STPANELS_PLUGIN_DIR:?}" ]; then
	STPANELS_PROPERTIES_FILE="${STPANELS_PLUGIN_DIR:?}"/stpanels.properties
	STPANELS_LICENSE_FILE="${STPANELS_PLUGIN_DIR:?}"/STPanels.key
	STPANELS_LICENSE=$(getVar STPANELS_LICENSE)

	if [ -n "${STTOOLS_TOKEN-}" ]; then
		if [ -e "${STPANELS_PROPERTIES_FILE:?}" ]; then
			sed -i "s|^\s*\(stpanels\.token\)\s*=.*$|\1=${STTOOLS_TOKEN-}|" "${STPANELS_PROPERTIES_FILE:?}"
		else
			printf '%s\n' "stpanels.token=${STTOOLS_TOKEN:?}" > "${STPANELS_PROPERTIES_FILE:?}"
		fi
	fi

	if [ -n "${STPANELS_LICENSE-}" ]; then
		printf '%s\n' "${STPANELS_LICENSE:?}" > "${STPANELS_LICENSE_FILE:?}"
	fi
fi

STPIVOT_PLUGIN_DIR="${CATALINA_BASE:?}"/webapps/"${WEBAPP_PENTAHO_DIRNAME:?}"/stpivot/
if [ -e "${STPIVOT_PLUGIN_DIR:?}" ]; then
	STPIVOT_PROPERTIES_FILE="${STPIVOT_PLUGIN_DIR:?}"/stpivot.properties
	STPIVOT_LICENSE_FILE="${STPIVOT_PLUGIN_DIR:?}"/STPivot.key
	STPIVOT_LICENSE=$(getVar STPIVOT_LICENSE)

	if [ -n "${STTOOLS_TOKEN-}" ]; then
		if [ -e "${STPIVOT_PROPERTIES_FILE:?}" ]; then
			sed -i "s|^\s*\(stpivot\.token\)\s*=.*$|\1=${STTOOLS_TOKEN-}|" "${STPIVOT_PROPERTIES_FILE:?}"
		else
			printf '%s\n' "stpivot.token=${STTOOLS_TOKEN:?}" > "${STPIVOT_PROPERTIES_FILE:?}"
		fi
	fi

	if [ -n "${STPIVOT_LICENSE-}" ]; then
		printf '%s\n' "${STPIVOT_LICENSE:?}" > "${STPIVOT_LICENSE_FILE:?}"
	fi
fi

STREPORT_PLUGIN_DIR="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/saiku-adhoc/
if [ -e "${STREPORT_PLUGIN_DIR:?}" ]; then
	STREPORT_PROPERTIES_FILE="${STREPORT_PLUGIN_DIR:?}"/saiku-adhoc.properties
	STREPORT_LICENSE_FILE="${STREPORT_PLUGIN_DIR:?}"/STReport.key
	STREPORT_LICENSE=$(getVar STREPORT_LICENSE)

	if [ -n "${STTOOLS_TOKEN-}" ]; then
		if [ -e "${STREPORT_PROPERTIES_FILE:?}" ]; then
			sed -i "s|^\s*\(saiku-adhoc\.metadata\.token\)\s*=.*$|\1=${STTOOLS_TOKEN-}|" "${STREPORT_PROPERTIES_FILE:?}"
		else
			printf '%s\n' "saiku-adhoc.metadata.token=${STTOOLS_TOKEN:?}" > "${STREPORT_PROPERTIES_FILE:?}"
		fi
	fi

	if [ -n "${STREPORT_LICENSE-}" ]; then
		printf '%s\n' "${STREPORT_LICENSE:?}" > "${STREPORT_LICENSE_FILE:?}"
	fi
fi
