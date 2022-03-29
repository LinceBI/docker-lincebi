FROM repo.stratebi.com/lincebi/biserver:9.2.0.0-290

ARG REPO_RAW_LINCEBI_URL="https://repo.stratebi.com/repository/lincebi-raw"
ARG REPO_MAVEN_LINCEBI_URL="https://repo.stratebi.com/repository/lincebi-mvn"

# Add LinceBI layer
ARG LINCEBI_VERSION="2.5.2"
ARG LINCEBI_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/lincebi/${LINCEBI_VERSION}/lincebi-${LINCEBI_VERSION}.zip"
ARG LINCEBI_CHECKSUM="cfdde0e35a918c344e4ee052c68f4ba596691d6cf44d224d287b15089a13a80e"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/10_lincebi.zip "${LINCEBI_URL:?}" \
	&& printf '%s  %s' "${LINCEBI_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/10_lincebi.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/10_lincebi.zip

# Add STSearch layer
ARG STSEARCH_VERSION="1.8.1"
ARG STSEARCH_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/stsearch/${STSEARCH_VERSION}/stsearch-${STSEARCH_VERSION}.zip"
ARG STSEARCH_CHECKSUM="cd5b26f14b5eb0efcbc28b604f0b0a3ce4419ba52d4178dbaa0090b2be86f5cf"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip "${STSEARCH_URL:?}" \
	&& printf '%s  %s' "${STSEARCH_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip

# Add Dynamic Schema Processor layer
ARG DSP_VERSION="1.3.0"
ARG DSP_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/dynamic-schema-processor/${DSP_VERSION}/dynamic-schema-processor-${DSP_VERSION}.jar"
ARG DSP_CHECKSUM="e5fb4f390aad58d117ed7349b72f4bcdd029e98a711898c7eb90d969a79952ea"
RUN mkdir -p "${BISERVER_PRIV_INITD:?}"/30_dsp/tomcat/webapps/"${WEBAPP_PENTAHO_DIRNAME}"/WEB-INF/lib/ \
	&& cd "${BISERVER_PRIV_INITD:?}"/30_dsp/tomcat/webapps/"${WEBAPP_PENTAHO_DIRNAME}"/WEB-INF/lib/ \
	&& curl -LO "${DSP_URL:?}" \
	&& printf '%s  %s' "${DSP_CHECKSUM:?}" ./dynamic-schema-processor-*.jar | sha256sum -c \
	&& find "${BISERVER_PRIV_INITD:?}"/30_dsp/ -type d -not -perm 0775 -exec chmod -c 0775 '{}' '+' \
	&& find "${BISERVER_PRIV_INITD:?}"/30_dsp/ -type f -not -perm 0664 -exec chmod -c 0664 '{}' '+'

# Add spanish language pack layer
ARG LANGUAGEPACK_ES_VERSION="9.2-21.09.13"
ARG LANGUAGEPACK_ES_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_es-${LANGUAGEPACK_ES_VERSION}.zip"
ARG LANGUAGEPACK_ES_CHECKSUM="5fce95cf1f979bd04a54d15c28c7bb431c6124c875b0a9599bb55767fd4f1f85"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip "${LANGUAGEPACK_ES_URL:?}" \
	&& printf '%s  %s' "${LANGUAGEPACK_ES_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip

# Add catalan language pack layer
ARG LANGUAGEPACK_CA_VERSION="9.2-21.09.13"
ARG LANGUAGEPACK_CA_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_ca-${LANGUAGEPACK_CA_VERSION}.zip"
ARG LANGUAGEPACK_CA_CHECKSUM="28cb56ef9326f912477867928993b1c1c97dfb0f1b2eb7510e4de90819675ee6"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip "${LANGUAGEPACK_CA_URL:?}" \
	&& printf '%s  %s' "${LANGUAGEPACK_CA_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip

# Add portuguese language pack layer
ARG LANGUAGEPACK_PT_VERSION="9.2-21.09.13"
ARG LANGUAGEPACK_PT_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_pt_PT-${LANGUAGEPACK_PT_VERSION}.zip"
ARG LANGUAGEPACK_PT_CHECKSUM="1c6aee971868d42586b14129d678d99457bdcf9100ac668483c8aa0711507d21"
RUN curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt.zip "${LANGUAGEPACK_PT_URL:?}" \
	&& printf '%s  %s' "${LANGUAGEPACK_PT_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt.zip | sha256sum -c \
	&& chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt.zip

# Copy Pentaho BI Server config
COPY --chown=biserver:root ./config/biserver.priv.init.d/ "${BISERVER_PRIV_INITD}"/
COPY --chown=biserver:root ./config/biserver.init.d/ "${BISERVER_INITD}"/

# Set correct permissions to support arbitrary user ids
RUN /usr/share/biserver/bin/update-permissions.sh
