FROM y.i.tomcat
MAINTAINER Mateus Prado<mateus@mateusprado.com>

ENV HYBRIS_ADMIN /hybrisAdmin

ENV HYBRIS_OPT_CONFIG_DIR /etc/hybris/localconfig
RUN mkdir -p ${HYBRIS_OPT_CONFIG_DIR}

RUN mkdir -p /etc/hybris/data
RUN mkdir -p /etc/hybris/temp
RUN mkdir -p /etc/hybris/log

ADD platform_config/*.properties ${HYBRIS_OPT_CONFIG_DIR}/
RUN echo "" >> ${HYBRIS_OPT_CONFIG_DIR}/env.properties &&\
    echo "HYBRIS_DATA_DIR=/etc/hybris/data" >> ${HYBRIS_OPT_CONFIG_DIR}/env.properties &&\
    echo "HYBRIS_LOG_DIR=/etc/hybris/log" >> ${HYBRIS_OPT_CONFIG_DIR}/env.properties &&\
    echo "HYBRIS_TEMP_DIR=/etc/hybris/temp" >> ${HYBRIS_OPT_CONFIG_DIR}/env.properties

ENV TOMCAT /opt/tomcat

ADD tomcat_lib/* ${TOMCAT}/lib/

ADD tomcat_conf/* ${TOMCAT}/conf/

ENV TOMCAT_SERVER_XML server_standalone.xml

ENV TC_HTTP_PORT 9001
ENV TC_HTTP_PROXY_PORT 80
ENV TC_HTTP_REDIRECT_PORT 443

ENV TC_HTTPS_PORT 9002
ENV TC_HTTPS_PROXY_PORT 443

ENV TC_AJP_PORT=9009

ENV TC_JMX_PORT 9003
ENV TC_JMX_SERVER_PORT 9004

ADD startHybrisTomcat.sh /usr/local/bin/startHybrisTomcat

ENV PLATFORM_PACKAGE /hybrisServer

ENV CATALINA_JAVA_OPTS -Xms2G -Xmx2G -XX:MaxPermSize=300M -ea -Dcom.sun.management.jmxremote \
-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false \
-Dorg.tanukisoftware.wrapper.WrapperManager.mbean=true -Dfile.encoding=UTF-8

CMD ["/usr/local/bin/startHybrisTomcat"]
