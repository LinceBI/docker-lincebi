FROM repo.stratebi.com/lincebi/biserver:9.0.0.0-423

ARG LINCEBI_RAW_URL="https://repo.stratebi.com/repository/lincebi-raw"
ARG LINCEBI_MAVEN_URL="https://repo.stratebi.com/repository/lincebi-mvn"

# Add LinceBI frontend layer
ARG LINCEBI_FRONTEND_VERSION="1.7.3"
ARG LINCEBI_FRONTEND_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/lincebi-biserver-frontend/${LINCEBI_FRONTEND_VERSION}/lincebi-biserver-frontend-${LINCEBI_FRONTEND_VERSION}.tgz"
ARG LINCEBI_FRONTEND_CHECKSUM="ae93c2737f71e22be370fa4f09a97e09fe825465317c1ce79454e9e2f64adefc"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/10_lincebi-biserver-frontend.tgz "${LINCEBI_FRONTEND_URL:?}" \
	&& printf '%s  %s' "${LINCEBI_FRONTEND_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/10_lincebi-biserver-frontend.tgz | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/10_lincebi-biserver-frontend.tgz

# Add file-metadata layer
ARG FILE_METADATA_VERSION="2.9.0"
ARG FILE_METADATA_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/file-metadata/${FILE_METADATA_VERSION}/file-metadata-${FILE_METADATA_VERSION}.zip"
ARG FILE_METADATA_CHECKSUM="ab7bf12e64607bb7c2fd6c494d442d5be00374ae81f404365e631c8438ddb819"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_file-metadata.zip "${FILE_METADATA_URL:?}" \
	&& printf '%s  %s' "${FILE_METADATA_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/20_file-metadata.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_file-metadata.zip

# Add global-user-settings layer
ARG GLOBAL_USER_SETTINGS_VERSION="1.4.0"
ARG GLOBAL_USER_SETTINGS_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/global-user-settings/${GLOBAL_USER_SETTINGS_VERSION}/global-user-settings-${GLOBAL_USER_SETTINGS_VERSION}.zip"
ARG GLOBAL_USER_SETTINGS_CHECKSUM="de0e9eb842c6df85ae5fe3230dcd407074409d475f35a0cf8426baedae5ab069"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_global-user-settings.zip "${GLOBAL_USER_SETTINGS_URL:?}" \
	&& printf '%s  %s' "${GLOBAL_USER_SETTINGS_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/20_global-user-settings.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_global-user-settings.zip

# Add STSearch layer
ARG STSEARCH_VERSION="1.5.2"
ARG STSEARCH_URL="${LINCEBI_MAVEN_URL}/com/stratebi/lincebi/stsearch/${STSEARCH_VERSION}/stsearch-${STSEARCH_VERSION}.zip"
ARG STSEARCH_CHECKSUM="255364816d03754ebbaa142bf295ffb069bcd3eb2a4f0e38a7dd81fdf2b011fd"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip "${STSEARCH_URL:?}" \
	&& printf '%s  %s' "${STSEARCH_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip

# Add spanish language pack layer
ARG LANGUAGEPACK_ES_VERSION="9.0-20.03.16"
ARG LANGUAGEPACK_ES_URL="${LINCEBI_RAW_URL}/pentaho-language-packs/languagePack_es-${LANGUAGEPACK_ES_VERSION}.zip"
ARG LANGUAGEPACK_ES_CHECKSUM="28786ee4e2e2b483e006ad4a613b6a9da56e73e6323fc7364e26d199236d6f4e"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip -u "${ARTIFACTORY_REPO_AUTH}" "${LANGUAGEPACK_ES_URL:?}" \
	&& printf '%s  %s' "${LANGUAGEPACK_ES_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip \
	# Add installer layer
	&& kjb_file="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_es/endpoints/kettle/admin/installpack.kjb \
	&& sh_src="/usr/share/biserver/bin/kitchen.sh -level=Error -file='${kjb_file:?}'" \
	&& printf '%s\n' '#!/bin/sh' "${sh_src:?}" > "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-es.sh \
	&& chmod 0775 "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-es.sh

# Add catalan language pack layer
ARG LANGUAGEPACK_CA_VERSION="9.0-20.03.16"
ARG LANGUAGEPACK_CA_URL="${LINCEBI_RAW_URL}/pentaho-language-packs/languagePack_ca-${LANGUAGEPACK_CA_VERSION}.zip"
ARG LANGUAGEPACK_CA_CHECKSUM="f0c7c236c1e3ffecd862c9193546cf27545292df59f95eca2dc6f2f9b5c1b77a"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip -u "${ARTIFACTORY_REPO_AUTH}" "${LANGUAGEPACK_CA_URL:?}" \
	&& printf '%s  %s' "${LANGUAGEPACK_CA_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip \
	# Add installer layer
	&& kjb_file="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_ca/endpoints/kettle/admin/installpack.kjb \
	&& sh_src="/usr/share/biserver/bin/kitchen.sh -level=Error -file='${kjb_file:?}'" \
	&& printf '%s\n' '#!/bin/sh' "${sh_src:?}" > "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-ca.sh \
	&& chmod 0775 "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-ca.sh

# Add portuguese language pack layer
ARG LANGUAGEPACK_PT_VERSION="9.0-20.03.16"
ARG LANGUAGEPACK_PT_URL="${LINCEBI_RAW_URL}/pentaho-language-packs/languagePack_pt_PT-${LANGUAGEPACK_PT_VERSION}.zip"
ARG LANGUAGEPACK_PT_CHECKSUM="32697afbbfca68b06b4563ac25dca620a6c7812d16e25dfe029ac0c664061e7c"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt.zip -u "${ARTIFACTORY_REPO_AUTH}" "${LANGUAGEPACK_PT_URL:?}" \
	&& printf '%s  %s' "${LANGUAGEPACK_PT_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt.zip \
	# Add installer layer
	&& kjb_file="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_pt_PT/endpoints/kettle/admin/installpack.kjb \
	&& sh_src="/usr/share/biserver/bin/kitchen.sh -level=Error -file='${kjb_file:?}'" \
	&& printf '%s\n' '#!/bin/sh' "${sh_src:?}" > "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-pt.sh \
	&& chmod 0775 "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-pt.sh

# Copy Pentaho BI Server config
COPY --chown=biserver:root ./config/biserver.priv.init.d/ "${BISERVER_PRIV_INITD}"/
COPY --chown=biserver:root ./config/biserver.init.d/ "${BISERVER_INITD}"/

# Set correct permissions to support arbitrary user ids
RUN /usr/share/biserver/bin/update-permissions.sh
