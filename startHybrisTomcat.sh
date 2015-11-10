#!/bin/bash
set -e

APP_BASE=${TOMCAT}/conf/Catalina/localhost
LIB=${TOMCAT}/lib

HYBRIS_WEBAPPS=${PLATFORM_PACKAGE}/conf/Catalina/localhost
HYBRIS_YTOMCAT=${PLATFORM_PACKAGE}/lib/ytomcat.jar


# ---------------------------------------------------------------------------
# Patch webapps if we've got them
# ---------------------------------------------------------------------------
if [ -d "${HYBRIS_WEBAPPS}" ]; then
  if [ -d "${APP_BASE}" ]; then
      echo "Cleaning app base ${APP_BASE}..."
      rm ${APP_BASE}/*.xml
  else
      mkdir -p ${APP_BASE}
  fi
  echo "Copying web apps from ${HYBRIS_WEBAPPS} to ${APP_BASE}"
  cp ${HYBRIS_WEBAPPS}/*.xml ${APP_BASE}
else
  echo "No platform webapps folder ${HYBRIS_WEBAPPS}!"
fi

# ---------------------------------------------------------------------------
# Patch ytomcat.jar if we've got one
# ---------------------------------------------------------------------------
if [ -f "${HYBRIS_YTOMCAT}" ]; then
  echo "Replacing ${LIB}/ytomcat.jar..."
  cp -f ${HYBRIS_YTOMCAT} ${LIB}/
else
  echo "No ytomcat.jar found at ${HYBRIS_YTOMCAT}!"
fi

# ---------------------------------------------------------------------------
# IP Address -> properties file
# ---------------------------------------------------------------------------
OWN_IP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
export y_cluster_broadcast_method_jgroups_tcp_bind__addr=${OWN_IP}


CATALINA_HYBRIS_OPTS="-DPLATFORM_HOME=${PLATFORM_PACKAGE}/hybris/bin/platform"

CATALINA_PORT_OPTS="-DTC_HTTP_PORT=${TC_HTTP_PORT} \
      -DTC_HTTP_REDIRECT_PORT=${TC_HTTP_REDIRECT_PORT} \
      -DTC_HTTP_PROXY_PORT=${TC_HTTP_PROXY_PORT} \
      -DTC_HTTPS_PORT=${TC_HTTPS_PORT} \
      -DTC_HTTPS_PROXY_PORT=${TC_HTTPS_PROXY_PORT} \
      -DTC_AJP_PORT=${TC_AJP_PORT} \
      -DTC_JMX_PORT=${TC_JMX_PORT} \
      -DTC_JMX_SERVER_PORT=${TC_JMX_SERVER_PORT}"

# ---------------------------------------------------------------------------
# Export Catalina & Platform env settings
# ---------------------------------------------------------------------------
export JAVA_OPTS="${CATALINA_JAVA_OPTS} ${CATALINA_HYBRIS_OPTS} ${CATALINA_PORT_OPTS}"

echo "--- hybris JAVA_OPTS  -------------------------------------------"
echo "${JAVA_OPTS}"
echo "-----------------------------------------------------------------"

exec ${TOMCAT}/bin/catalina.sh run -config conf/${TOMCAT_SERVER_XML}
