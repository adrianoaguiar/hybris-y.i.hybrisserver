
  Server Image y.i.hybrisserver
  =============================

  This image is based on the hybris tomcat image and prepares a server for
  running a platform on tomcat. It does these steps:

  * adds database drivers to tomcat lib
  * adds utils for environment->properties
  * changes server.xml
  * adds startHybrisTomcat.sh

  build as: make
