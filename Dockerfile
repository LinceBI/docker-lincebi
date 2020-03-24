FROM repo.stratebi.com/lincebi/biserver:8.2.0.0-342

ARG LINCEBI_MAVEN_URL="https://repo.stratebi.com/repository/lincebi-mvn"

# Install LinceBI frontend
ARG LINCEBI_FRONTEND_VERSION=1.4.3
ARG LINCEBI_FRONTEND_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/lincebi-biserver-frontend/${LINCEBI_FRONTEND_VERSION}/lincebi-biserver-frontend-${LINCEBI_FRONTEND_VERSION}.tgz"
RUN curl -fsSL "${LINCEBI_FRONTEND_URL:?}" | tar -xzC "${BISERVER_HOME:?}"

# Install file-metadata
ARG FILE_METADATA_VERSION=2.8.0
ARG FILE_METADATA_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/file-metadata/${FILE_METADATA_VERSION}/file-metadata-${FILE_METADATA_VERSION}.zip"
RUN cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ \
	&& curl -fsSL "${FILE_METADATA_URL:?}" > ./file-metadata.zip \
	&& unzip -qo ./file-metadata.zip \
	&& rm -f ./file-metadata.zip

# Install global-user-settings
ARG GLOBAL_USER_SETTINGS_VERSION=1.4.0
ARG GLOBAL_USER_SETTINGS_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/global-user-settings/${GLOBAL_USER_SETTINGS_VERSION}/global-user-settings-${GLOBAL_USER_SETTINGS_VERSION}.zip"
RUN cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ \
	&& curl -fsSL "${GLOBAL_USER_SETTINGS_URL:?}" > ./global-user-settings.zip \
	&& unzip -qo ./global-user-settings.zip \
	&& rm -f ./global-user-settings.zip

# Install STSearch
ARG STSEARCH_VERSION=1.4.3
ARG STSEARCH_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/stsearch/${STSEARCH_VERSION}/stsearch-${STSEARCH_VERSION}.zip"
RUN cd "${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/ \
	&& curl -fsSL "${STSEARCH_URL:?}" > ./stsearch.zip \
	&& unzip -qo ./stsearch.zip \
	&& rm -f ./stsearch.zip

# Install language packs
ARG LANGUAGEPACKS_LIST=es,ca
ARG LANGUAGEPACKS_VERSION=9.0-20.03.16
ARG LANGUAGEPACKS_URL_BASE="https://repo.stratebi.com/repository/lincebi-raw/pentaho-language-packs"
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
	done

# Copy Pentaho BI Server config
COPY --chown=biserver:root ./config/biserver/pentaho-solutions/ "${BISERVER_HOME}"/"${SOLUTIONS_DIRNAME}"/
COPY --chown=biserver:root ./config/biserver.init.d/ "${BISERVER_INITD}"/

# Set sane permissions until solved upstream:
# https://gitlab.com/gitlab-org/gitlab-runner/issues/1736
RUN find "${BISERVER_HOME:?}" -type d -not -perm 0775 -exec chmod 0775 '{}' '+' \
	&& find "${BISERVER_HOME:?}" -type f -not '(' -perm 0664 -o -regex '.*\.sh\(\.erb\)?$' ')' -exec chmod 0664 '{}' '+' \
	&& find "${BISERVER_HOME:?}" -type f '(' -not -perm 0775 -a -regex '.*\.sh\(\.erb\)?$' ')' -exec chmod 0775 '{}' '+' \
	&& find "${BISERVER_INITD:?}" /home/biserver/ -type d -not -perm 0775 -exec chmod 0775 '{}' '+' \
	&& find "${BISERVER_INITD:?}" /home/biserver/ -type f -not '(' -perm 0664 -o -regex '.*\.\(sh\|run\)$' ')' -exec chmod 0664 '{}' '+' \
	&& find "${BISERVER_INITD:?}" /home/biserver/ -type f '(' -not -perm 0775 -a -regex '.*\.\(sh\|run\)$' ')' -exec chmod 0775 '{}' '+' \
	&& find /usr/share/biserver/bin/ /usr/share/biserver/service/ -not -perm 0775 -exec chmod 0775 '{}' '+'
