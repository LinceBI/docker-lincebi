FROM repo.stratebi.com/lincebi/biserver:8.3.0.15-977

ARG REPO_RAW_LINCEBI_URL="https://repo.stratebi.com/repository/lincebi-raw"
ARG REPO_MAVEN_LINCEBI_URL="https://repo.stratebi.com/repository/lincebi-mvn"

# Add LinceBI frontend layer
ARG LINCEBI_FRONTEND_VERSION="1.7.6"
ARG LINCEBI_FRONTEND_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/lincebi-biserver-frontend/${LINCEBI_FRONTEND_VERSION}/lincebi-biserver-frontend-${LINCEBI_FRONTEND_VERSION}.tgz"
ARG LINCEBI_FRONTEND_CHECKSUM="5b6618495535e65665922b8565326338c653eb92ec79befe74a2d0486395f590"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/10_lincebi-biserver-frontend.tgz "${LINCEBI_FRONTEND_URL:?}" \
	&& printf '%s  %s' "${LINCEBI_FRONTEND_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/10_lincebi-biserver-frontend.tgz | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/10_lincebi-biserver-frontend.tgz

# Add file-metadata layer
ARG FILE_METADATA_VERSION="2.9.2"
ARG FILE_METADATA_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/file-metadata/${FILE_METADATA_VERSION}/file-metadata-${FILE_METADATA_VERSION}.zip"
ARG FILE_METADATA_CHECKSUM="7c5f0bdb49df56507ec9a7b4e6aa3244b613e1d6b41a00074efdb11a309910d9"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_file-metadata.zip "${FILE_METADATA_URL:?}" \
	&& printf '%s  %s' "${FILE_METADATA_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/20_file-metadata.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_file-metadata.zip

# Add global-user-settings layer
ARG GLOBAL_USER_SETTINGS_VERSION="1.4.1"
ARG GLOBAL_USER_SETTINGS_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/global-user-settings/${GLOBAL_USER_SETTINGS_VERSION}/global-user-settings-${GLOBAL_USER_SETTINGS_VERSION}.zip"
ARG GLOBAL_USER_SETTINGS_CHECKSUM="5c327f1e7da6fbead8812d509b337fdefd190071c56e1e27aa2271bcf5a61012"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_global-user-settings.zip "${GLOBAL_USER_SETTINGS_URL:?}" \
	&& printf '%s  %s' "${GLOBAL_USER_SETTINGS_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/20_global-user-settings.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_global-user-settings.zip

# Add STSearch layer
ARG STSEARCH_VERSION="1.5.6"
ARG STSEARCH_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/stsearch/${STSEARCH_VERSION}/stsearch-${STSEARCH_VERSION}.zip"
ARG STSEARCH_CHECKSUM="a7f0588788b967d47e889fd42bb8f7a37654b88c6dc8a9273cdfa7598b561c64"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip "${STSEARCH_URL:?}" \
	&& printf '%s  %s' "${STSEARCH_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip

# Add spanish language pack layer
ARG LANGUAGEPACK_ES_VERSION="9.1-20.10.13"
ARG LANGUAGEPACK_ES_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_es-${LANGUAGEPACK_ES_VERSION}.zip"
ARG LANGUAGEPACK_ES_CHECKSUM="1b66fb84c930d06fb8bcdec249c1e7c7e11203c0b0c5056222387cbe2d6c746f"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip "${LANGUAGEPACK_ES_URL:?}" \
	&& printf '%s  %s' "${LANGUAGEPACK_ES_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip \
	# Add installer layer
	&& kjb_file="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_es/endpoints/kettle/admin/installpack.kjb \
	&& sh_src="/usr/share/biserver/bin/kitchen.sh -level=Error -file='${kjb_file:?}'" \
	&& printf '%s\n' '#!/bin/sh' "${sh_src:?}" > "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-es.sh \
	&& chmod 0775 "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-es.sh

# Add catalan language pack layer
ARG LANGUAGEPACK_CA_VERSION="9.1-20.10.13"
ARG LANGUAGEPACK_CA_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_ca-${LANGUAGEPACK_CA_VERSION}.zip"
ARG LANGUAGEPACK_CA_CHECKSUM="55fbcecada8017b6d73897dc5b3255b1f8fb8b6dee134bbd6e4fb7bdd11ac1b9"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip "${LANGUAGEPACK_CA_URL:?}" \
	&& printf '%s  %s' "${LANGUAGEPACK_CA_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip \
	# Add installer layer
	&& kjb_file="${BISERVER_HOME:?}"/"${SOLUTIONS_DIRNAME:?}"/system/languagePack_ca/endpoints/kettle/admin/installpack.kjb \
	&& sh_src="/usr/share/biserver/bin/kitchen.sh -level=Error -file='${kjb_file:?}'" \
	&& printf '%s\n' '#!/bin/sh' "${sh_src:?}" > "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-ca.sh \
	&& chmod 0775 "${BISERVER_PRIV_INITD:?}"/40_setup-language-pack-ca.sh

# Add portuguese language pack layer
ARG LANGUAGEPACK_PT_VERSION="9.1-20.10.13"
ARG LANGUAGEPACK_PT_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_pt_PT-${LANGUAGEPACK_PT_VERSION}.zip"
ARG LANGUAGEPACK_PT_CHECKSUM="665487abd57b618493b728e7403ca566ff6f6189ab0b2b911bbe1e04152708aa"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt.zip "${LANGUAGEPACK_PT_URL:?}" \
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
