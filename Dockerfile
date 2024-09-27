FROM repo.stratebi.com/lincebi/biserver:9.3.0.9-878-1

ARG REPO_RAW_LINCEBI_URL="https://repo.stratebi.com/repository/lincebi-raw"
ARG REPO_MAVEN_LINCEBI_URL="https://repo.stratebi.com/repository/lincebi-mvn"

# Add LinceBI layer
ARG LINCEBI_VERSION="2.13.0"
ARG LINCEBI_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/lincebi/${LINCEBI_VERSION}/lincebi-${LINCEBI_VERSION}.zip"
ARG LINCEBI_CHECKSUM="a2b7fdac041d04a4c12c95c7fb4315568b846c49c6151321365bedf426845b0d"
RUN <<-EOF
	curl -Lo "${BISERVER_PRIV_INITD:?}"/10_lincebi.zip "${LINCEBI_URL:?}"
	printf '%s  %s' "${LINCEBI_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/10_lincebi.zip | sha256sum -c
	chmod 0664 "${BISERVER_PRIV_INITD:?}"/10_lincebi.zip
EOF

# Add STSearch layer
ARG STSEARCH_VERSION="1.10.0"
ARG STSEARCH_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/stsearch/${STSEARCH_VERSION}/stsearch-${STSEARCH_VERSION}.zip"
ARG STSEARCH_CHECKSUM="1a24868e15d1a9c841bb65ebbac7adbcb6ad6e14e7fe0c8695b13feee6e2ab30"
RUN <<-EOF
	curl -Lo "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip "${STSEARCH_URL:?}"
	printf '%s  %s' "${STSEARCH_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip | sha256sum -c
	chmod 0664 "${BISERVER_PRIV_INITD:?}"/20_stsearch.zip
EOF

# Add Dynamic Schema Processor layer
ARG DSP_VERSION="1.3.8"
ARG DSP_URL="${REPO_MAVEN_LINCEBI_URL}/com/stratebi/lincebi/dynamic-schema-processor/${DSP_VERSION}/dynamic-schema-processor-${DSP_VERSION}.jar"
ARG DSP_CHECKSUM="7e5957a25e677f95d8da96447072d549482ed2c8ac9d7fba9d569b3b9f6765fb"
RUN <<-EOF
	mkdir -p "${BISERVER_PRIV_INITD:?}"/30_dsp/tomcat/webapps/"${WEBAPP_PENTAHO_DIRNAME}"/WEB-INF/lib/
	cd "${BISERVER_PRIV_INITD:?}"/30_dsp/tomcat/webapps/"${WEBAPP_PENTAHO_DIRNAME}"/WEB-INF/lib/
	curl -LO "${DSP_URL:?}"
	printf '%s  %s' "${DSP_CHECKSUM:?}" ./dynamic-schema-processor-*.jar | sha256sum -c
	find "${BISERVER_PRIV_INITD:?}"/30_dsp/ -type d -not -perm 0775 -exec chmod -c 0775 '{}' '+'
	find "${BISERVER_PRIV_INITD:?}"/30_dsp/ -type f -not -perm 0664 -exec chmod -c 0664 '{}' '+'
EOF

# Add catalan language pack layer
ARG LANGUAGEPACK_CA_VERSION="9.3-22.06.13"
ARG LANGUAGEPACK_CA_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_ca-${LANGUAGEPACK_CA_VERSION}.zip"
ARG LANGUAGEPACK_CA_CHECKSUM="56230486d3a6476174c43ab92b363e6dc51f37de9f765f9979193364200ba40a"
RUN <<-EOF
	curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip "${LANGUAGEPACK_CA_URL:?}"
	printf '%s  %s' "${LANGUAGEPACK_CA_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip | sha256sum -c
	chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-ca.zip
EOF

# Add korean language pack layer
ARG LANGUAGEPACK_KO_VERSION="9.3-22.06.13"
ARG LANGUAGEPACK_KO_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_ko-${LANGUAGEPACK_KO_VERSION}.zip"
ARG LANGUAGEPACK_KO_CHECKSUM="97466542b711d7a37be79afc88c7a7c48d8c8ccfb3c8ffc2c93a9d6d235f5d4c"
RUN <<-EOF
	curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-ko.zip "${LANGUAGEPACK_KO_URL:?}"
	printf '%s  %s' "${LANGUAGEPACK_KO_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-ko.zip | sha256sum -c
	chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-ko.zip
EOF

# Add portuguese (PT) language pack layer
ARG LANGUAGEPACK_PT_PT_VERSION="9.3-22.06.13"
ARG LANGUAGEPACK_PT_PT_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_pt_PT-${LANGUAGEPACK_PT_PT_VERSION}.zip"
ARG LANGUAGEPACK_PT_PT_CHECKSUM="7ba32e302dfe69bdf94d14fd0fdf0393ba01deb5284ec1bb338699c540c85e8b"
RUN <<-EOF
	curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt_PT.zip "${LANGUAGEPACK_PT_PT_URL:?}"
	printf '%s  %s' "${LANGUAGEPACK_PT_PT_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt_PT.zip | sha256sum -c
	chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt_PT.zip
EOF

# Add portuguese (BR) language pack layer
ARG LANGUAGEPACK_PT_BR_VERSION="9.3-22.06.13"
ARG LANGUAGEPACK_PT_BR_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_pt_BR-${LANGUAGEPACK_PT_BR_VERSION}.zip"
ARG LANGUAGEPACK_PT_BR_CHECKSUM="a7406a4db7ee3f7950b761f92570f903b37fa945024c82cc2dc2de5889d4946d"
RUN <<-EOF
	curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt_BR.zip "${LANGUAGEPACK_PT_BR_URL:?}"
	printf '%s  %s' "${LANGUAGEPACK_PT_BR_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt_BR.zip | sha256sum -c
	chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-pt_BR.zip
EOF

# Add spanish language pack layer
ARG LANGUAGEPACK_ES_VERSION="9.3-22.06.13"
ARG LANGUAGEPACK_ES_URL="${REPO_RAW_LINCEBI_URL}/pentaho-language-packs/languagePack_es-${LANGUAGEPACK_ES_VERSION}.zip"
ARG LANGUAGEPACK_ES_CHECKSUM="7b26def039742182027b2a8bcc31b9581aa2183b86fbba5115dde6cacd84694e"
RUN <<-EOF
	curl -Lo "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip "${LANGUAGEPACK_ES_URL:?}"
	printf '%s  %s' "${LANGUAGEPACK_ES_CHECKSUM:?}" "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip | sha256sum -c
	chmod 0664 "${BISERVER_PRIV_INITD:?}"/30_language-pack-es.zip
EOF

# Copy Pentaho BI Server config
COPY --chown=biserver:root ./config/biserver.priv.init.d/ "${BISERVER_PRIV_INITD}"/
COPY --chown=biserver:root ./config/biserver.init.d/ "${BISERVER_INITD}"/

# Set correct permissions to support arbitrary user ids
RUN /usr/share/biserver/bin/update-permissions.sh
