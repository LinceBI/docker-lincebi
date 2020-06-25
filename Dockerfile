FROM repo.stratebi.com/lincebi/biserver:8.2.0.0-342

ARG LINCEBI_RAW_URL="https://repo.stratebi.com/repository/lincebi-raw"
ARG LINCEBI_MAVEN_URL="https://repo.stratebi.com/repository/lincebi-mvn"

# Add LinceBI frontend layer
ARG LINCEBI_FRONTEND_VERSION=1.7.3
ARG LINCEBI_FRONTEND_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/lincebi-biserver-frontend/${LINCEBI_FRONTEND_VERSION}/lincebi-biserver-frontend-${LINCEBI_FRONTEND_VERSION}.tgz"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/10_lincebi-biserver-frontend.tgz "${LINCEBI_FRONTEND_URL:?}" \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/10_lincebi-biserver-frontend.tgz

# Add file-metadata layer
ARG FILE_METADATA_VERSION=2.8.0
ARG FILE_METADATA_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/file-metadata/${FILE_METADATA_VERSION}/file-metadata-${FILE_METADATA_VERSION}.zip"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_file-metadata.zip "${FILE_METADATA_URL:?}" \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_file-metadata.zip

# Add global-user-settings layer
ARG GLOBAL_USER_SETTINGS_VERSION=1.4.0
ARG GLOBAL_USER_SETTINGS_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/global-user-settings/${GLOBAL_USER_SETTINGS_VERSION}/global-user-settings-${GLOBAL_USER_SETTINGS_VERSION}.zip"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_global-user-settings.zip "${GLOBAL_USER_SETTINGS_URL:?}" \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_global-user-settings.zip

# Add STSearch layer
ARG STSEARCH_VERSION=1.5.2
ARG STSEARCH_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/stsearch/${STSEARCH_VERSION}/stsearch-${STSEARCH_VERSION}.zip"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip "${STSEARCH_URL:?}" \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip

# Add language packs layers
ARG LANGUAGEPACKS_LIST=es,ca,pt_PT
ARG LANGUAGEPACKS_VERSION=9.0-20.03.16
ARG LANGUAGEPACKS_URL_BASE="${LINCEBI_RAW_URL}/pentaho-language-packs"
RUN IFS=,; for lang in ${LANGUAGEPACKS_LIST-}; do \
		url="${LANGUAGEPACKS_URL_BASE:?}"/languagePack_"${lang:?}"-"${LANGUAGEPACKS_VERSION}".zip \
		&& pkglayer="${BISERVER_PRIV_INITD:?}"/30_language-pack-"${lang:?}".zip \
		&& etllayer="${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-"${lang:?}".sh \
		&& curl -Lo "${pkglayer:?}" "${url:?}" \
		&& kjb="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_"${lang:?}"/endpoints/kettle/admin/installpack.kjb \
		&& printf '%s\n' '#!/bin/sh' "/usr/share/biserver/bin/kitchen.sh -level=Error -file='${kjb:?}'" > "${etllayer:?}" \
		&& chmod 0664 "${pkglayer:?}" && chmod 0775 "${etllayer:?}"; \
	done

# Copy Pentaho BI Server config
COPY --chown=biserver:root ./config/biserver.priv.init.d/ "${BISERVER_PRIV_INITD}"/
COPY --chown=biserver:root ./config/biserver.init.d/ "${BISERVER_INITD}"/

# Set correct permissions to support arbitrary user ids
RUN /usr/share/biserver/bin/update-permissions.sh
