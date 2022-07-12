FROM ubuntu:20.04

Run apt-get update && apt-get install -y    unzip

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get clean;
    
# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d && \
    mkdir -p /home/pdi && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/pdi:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/pdi && \
    chmod 0440 /etc/sudoers.d/pdi && \
    chown ${uid}:${gid} -R /home/pdi


WORKDIR /home/pdi/

#Arguments definition
ARG INSTALLATION_PATH=/home/pdi
## Arguments for regular Pentaho client install
ARG PENTAHO_INSTALLER_NAME=pdi-ce
ARG PENTAHO_VERSION=9.3.0.0
ARG PENTAHO_PACKAGE_DIST=428
ARG FILE_SOFTWARE=${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}.zip
ARG FILE_RELEASE_NAME=${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}


#Copy to temporary location the content of predownloaded folder
COPY ./predownloaded/* /home/pdi/

##########################################

RUN if [ ! -f "/home/pdi/$FILE_SOFTWARE" ]; \
        then \
        echo "File $FILE_SOFTWARE Not Found in predownloaded, please download and copy to predownloaded folder"; exit 2; \
        fi;

# UNZIP and INSNTALL the Pentaho Client 
RUN unzip ${FILE_SOFTWARE}; 


COPY ./resources/* ${INSTALLATION_PATH}/data-integration/


# Create unprivileged user
ENV PENTAHO_UID=5000
ENV PENTAHO_USER=developer
ENV PENTAHO_HOME=${INSTALLATION_PATH}/data-integration 
ENV PENTAHO_LICENSE_PATH=

#This Setting is to skipe WEB TOOLKIT GTK Check. Since the use of this mack normally does no use GUI.
# If you want GUI, then istall libwebkitgtk-1.0-0 as the line commented above
ENV SKIP_WEBKITGTK_CHECK=1


#Assign permissions to pentaho on /opt/pentaho
RUN chown -R developer:root ${INSTALLATION_PATH}

#Setup JVM level parameters/variables
ENV PENTAHO_DI_JAVA_OPTIONS="-Dfile.encoding=utf8 -Dpentaho.installed.licenses.file=${INSTALLATION_PATH}/pentahoLicense/installedLicenses.xml -XX:+UseConcMarkSweepGC -XX:+ExplicitGCInvokesConcurrent -XX:+CMSClassUnloadingEnabled -XX:+AggressiveOpts" 


USER developer
ENV HOME /home/pdi
CMD /home/pdi/data-integration/./spoon.sh
#CMD ${INSTALLATION_PATH}/data-integration/./spoon.sh