FROM repo.stratebi.com/lincebi/biserver:8.2.0.0-342

ARG LINCEBI_RAW_URL="https://repo.stratebi.com/repository/lincebi-raw"
ARG LINCEBI_MAVEN_URL="https://repo.stratebi.com/repository/lincebi-mvn"

# Install LinceBI frontend
ARG LINCEBI_FRONTEND_VERSION=1.4.8
ARG LINCEBI_FRONTEND_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/lincebi-biserver-frontend/${LINCEBI_FRONTEND_VERSION}/lincebi-biserver-frontend-${LINCEBI_FRONTEND_VERSION}.tgz"
RUN curl -fsSL "${LINCEBI_FRONTEND_URL:?}" | tar -xzC "${BISERVER_HOME:?}" \
	&& /usr/share/biserver/bin/update-permissions.sh >/dev/null

# Install file-metadata
ARG FILE_METADATA_VERSION=2.8.0
ARG FILE_METADATA_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/file-metadata/${FILE_METADATA_VERSION}/file-metadata-${FILE_METADATA_VERSION}.zip"
RUN cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ \
	&& curl -fsSL "${FILE_METADATA_URL:?}" > ./file-metadata.zip \
	&& unzip -qo ./file-metadata.zip \
	&& rm -f ./file-metadata.zip \
	&& /usr/share/biserver/bin/update-permissions.sh >/dev/null

# Install global-user-settings
ARG GLOBAL_USER_SETTINGS_VERSION=1.4.0
ARG GLOBAL_USER_SETTINGS_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/global-user-settings/${GLOBAL_USER_SETTINGS_VERSION}/global-user-settings-${GLOBAL_USER_SETTINGS_VERSION}.zip"
RUN cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ \
	&& curl -fsSL "${GLOBAL_USER_SETTINGS_URL:?}" > ./global-user-settings.zip \
	&& unzip -qo ./global-user-settings.zip \
	&& rm -f ./global-user-settings.zip \
	&& /usr/share/biserver/bin/update-permissions.sh >/dev/null

# Install STSearch
ARG STSEARCH_VERSION=1.4.5
ARG STSEARCH_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/stsearch/${STSEARCH_VERSION}/stsearch-${STSEARCH_VERSION}.zip"
RUN cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ \
	&& curl -fsSL "${STSEARCH_URL:?}" > ./stsearch.zip \
	&& unzip -qo ./stsearch.zip \
	&& rm -f ./stsearch.zip \
	&& /usr/share/biserver/bin/update-permissions.sh >/dev/null

# Install language packs
ARG LANGUAGEPACKS_LIST=es,ca
ARG LANGUAGEPACKS_VERSION=9.0-20.03.16
ARG LANGUAGEPACKS_URL_BASE="${LINCEBI_RAW_URL}/pentaho-language-packs"
RUN IFS=,; for lang in ${LANGUAGEPACKS_LIST-}; do \
		url="${LANGUAGEPACKS_URL_BASE:?}"/languagePack_"${lang:?}"-"${LANGUAGEPACKS_VERSION}".zip; \
		pkg="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_"${lang:?}"-"${LANGUAGEPACKS_VERSION}".zip; \
		dst="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/; \
		dir="${dst:?}"/languagePack_"${lang:?}"; \
		kjb="${dir:?}"/endpoints/kettle/admin/installpack.kjb; \
		curl -fsSL "${url:?}" > "${pkg:?}"; \
		unzip -qo "${pkg:?}" -d "${dst:?}"; \
		/usr/share/biserver/bin/kitchen.sh -level=Error -file="${kjb:?}"; \
		rm -f "${pkg:?}"; \
	done \
	&& /usr/share/biserver/bin/update-permissions.sh >/dev/null

# Copy Pentaho BI Server config
COPY --chown=biserver:root ./config/biserver/pentaho-solutions/ "${BISERVER_HOME}"/"${SOLUTIONS_DIRNAME}"/
COPY --chown=biserver:root ./config/biserver.init.d/ "${BISERVER_INITD}"/

# Set correct permissions to support arbitrary user ids
RUN /usr/share/biserver/bin/update-permissions.sh
