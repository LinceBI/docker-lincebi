FROM repo.stratebi.com/lincebi/biserver:8.2.0.0-342

ARG LINCEBI_MAVEN_URL="https://repo.stratebi.com/repository/lincebi-mvn"

# Install LinceBI frontend
ARG LINCEBI_FRONTEND_VERSION=1.4.0
ARG LINCEBI_FRONTEND_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/lincebi-biserver-frontend/${LINCEBI_FRONTEND_VERSION}/lincebi-biserver-frontend-${LINCEBI_FRONTEND_VERSION}.tgz"
RUN curl -fsSL "${LINCEBI_FRONTEND_URL:?}" | tar -xzC "${BISERVER_HOME:?}"

# Install file-metadata
ARG FILE_METADATA_VERSION=2.7.1
ARG FILE_METADATA_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/file-metadata/${FILE_METADATA_VERSION}/file-metadata-${FILE_METADATA_VERSION}.zip"
RUN curl -fsSL "${FILE_METADATA_URL:?}" > "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/file-metadata.zip \
	&& cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ && unzip -qo ./file-metadata.zip && rm -f ./file-metadata.zip

# Install global-user-settings
ARG GLOBAL_USER_SETTINGS_VERSION=1.3.0
ARG GLOBAL_USER_SETTINGS_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/global-user-settings/${GLOBAL_USER_SETTINGS_VERSION}/global-user-settings-${GLOBAL_USER_SETTINGS_VERSION}.zip"
RUN curl -fsSL "${GLOBAL_USER_SETTINGS_URL:?}" > "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/global-user-settings.zip \
	&& cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ && unzip -qo ./global-user-settings.zip && rm -f ./global-user-settings.zip

# Install STSearch
ARG STSEARCH_VERSION=1.4.0
ARG STSEARCH_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/stsearch/${STSEARCH_VERSION}/stsearch-${STSEARCH_VERSION}.zip"
RUN curl -fsSL "${STSEARCH_URL:?}" > "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/stsearch.zip \
	&& cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ && unzip -qo ./stsearch.zip && rm -f ./stsearch.zip

# Install language packs
ARG LANGUAGEPACKS_LIST=ca,de,es,fr,it,pt_BR
ARG LANGUAGEPACKS_VERSION=8.2-18.12.06
ARG LANGUAGEPACKS_URL_BASE="https://github.com/webdetails/pentahoLanguagePacks/releases/download/${LANGUAGEPACKS_VERSION}"
RUN IFS=,; for lang in ${LANGUAGEPACKS_LIST-}; do \
		url="${LANGUAGEPACKS_URL_BASE:?}"/languagepack_"${lang:?}"-"${LANGUAGEPACKS_VERSION}".zip; \
		pkg="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagepack_"${lang:?}"-"${LANGUAGEPACKS_VERSION}".zip; \
		dst="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/; \
		dir="${dst:?}"/languagePack_"${lang:?}"; \
		kjb="${dir:?}"/endpoints/kettle/admin/installpack.kjb; \
		curl -fsSL "${url:?}" > "${pkg:?}"; \
		unzip -qo "${pkg:?}" -d "${dst:?}"; \
		/usr/share/biserver/bin/kitchen.sh -level=Error -file="${kjb:?}"; \
		rm -f "${pkg:?}"; \
	done

# Copy Pentaho BI Server config
COPY --chown=biserver:biserver ./config/biserver/pentaho-solutions/ "${BISERVER_HOME}"/"${SOLUTIONS_DIRNAME}"/
COPY --chown=root:root ./config/biserver.init.d/ "${BISERVER_INITD}"/
