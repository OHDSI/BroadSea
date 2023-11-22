#!/bin/sh
set -e

export DATASOURCE_PASSWORD="$(cat /run/secrets/WEBAPI_DATASOURCE_PASSWORD)"
export FLYWAY_DATASOURCE_PASSWORD="$(cat /run/secrets/WEBAPI_DATASOURCE_PASSWORD)"
export SECURITY_LDAP_SYSTEM_PASSWORD="$(cat /run/secrets/SECURITY_LDAP_SYSTEM_PASSWORD)"
export SECURITY_DB_DATASOURCE_PASSWORD="$(cat /run/secrets/SECURITY_DB_DATASOURCE_PASSWORD)"
export SECURITY_AD_SYSTEM_PASSWORD="$(cat /run/secrets/SECURITY_AD_SYSTEM_PASSWORD)"
export SECURITY_OAUTH_GOOGLE_APISECRET="$(cat /run/secrets/SECURITY_OAUTH_GOOGLE_APISECRET)"
export SECURITY_OAUTH_FACEBOOK_APISECRET="$(cat /run/secrets/SECURITY_OAUTH_FACEBOOK_APISECRET)"
export SECURITY_OAUTH_GITHUB_APISECRET="$(cat /run/secrets/SECURITY_OAUTH_GITHUB_APISECRET)"
export SECURITY_SAML_KEYMANAGER_STOREPASSWORD="$(cat /run/secrets/SECURITY_SAML_KEYMANAGER_STOREPASSWORD)"
export SECURITY_SAML_KEYMANAGER_PASSWORDS_ARACHNENETWORK="$(cat /run/secrets/SECURITY_SAML_KEYMANAGER_PASSWORDS_ARACHNENETWORK)"

JAVA_KEYSTORE="/usr/local/openjdk-8/lib/security/cacerts"
if [ -s "/tmp/cacerts" ]; then
    JAVA_KEYSTORE=/tmp/cacerts
    #cp -fr /tmp/cacerts /usr/local/openjdk-8/lib/security/cacerts
fi

cd /var/lib/ohdsi/webapi
exec java -Djavax.net.ssl.trustStore=${JAVA_KEYSTORE} \
    ${DEFAULT_JAVA_OPTS} ${JAVA_OPTS} \
    -cp ".:WebAPI.jar:WEB-INF/lib/*.jar${CLASSPATH}" \
    org.springframework.boot.loader.WarLauncher

