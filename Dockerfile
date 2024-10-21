FROM ubi8/ubi:8.7

LABEL name="Nexus Repository Manager" \
      authors="Dominik Martic <dominik.martic@proton.me>" \
      summary="The Nexus Repository Manager server \
          with universal support for popular component formats." \
      description="The Nexus Repository Manager server \
          with universal support for popular component formats." \
      run="podman run -d --name NAME \
           -p 8081:8081 \
           IMAGE" \
      stop="podman stop NAME"

ARG JAVA_VERSION="1.8.0"
ARG NEXUS_VERSION="3.37.3-02"
ARG NEXUS_DOWNLOAD_URL="https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz"
ARG NEXUS_DOWNLOAD_SHA256_HASH=c1db431908c5a76b44015c555d6ef4517abf0a86844faffee0f5d6c62359312d

# Configure nexus runtime
ENV NEXUS_HOME="/opt/nexus" \
    NEXUS_CONTEXT="nexus"
    

# Install Java & tar
RUN yum update -y \
    && yum --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y \
    java-${JAVA_VERSION}-openjdk-devel tar \
    && yum clean all \
    && groupadd --gid 200 -r nexus \
    && useradd --uid 200 -r nexus -g nexus -s /bin/false -d ${NEXUS_HOME} -c 'Nexus Repository Manager user'

WORKDIR ${NEXUS_HOME}

# Download nexus & setup directories
RUN curl -L ${NEXUS_DOWNLOAD_URL} --output nexus-${NEXUS_VERSION}-${JAVA_VERSION}-unix.tar.gz \
    && echo "${NEXUS_DOWNLOAD_SHA256_HASH} nexus-${NEXUS_VERSION}-${JAVA_VERSION}-unix.tar.gz" > nexus-${NEXUS_VERSION}-${JAVA_VERSION}-unix.tar.gz.sha256 \
    && sha256sum -c nexus-${NEXUS_VERSION}-${JAVA_VERSION}-unix.tar.gz.sha256 \
    && tar -xvf nexus-${NEXUS_VERSION}-${JAVA_VERSION}-unix.tar.gz \
    && rm -f nexus-${NEXUS_VERSION}-${JAVA_VERSION}-unix.tar.gz nexus-${NEXUS_VERSION}-${JAVA_VERSION}-unix.tar.gz.sha256 \
    && chown -R nexus:nexus /opt/nexus/sonatype-work

# Removing java memory settings from nexus.vmoptions since now we use INSTALL4J_ADD_VM_PARAMS
RUN sed -i '/^-Xms/d;/^-Xmx/d;/^-XX:MaxDirectMemorySize/d' ${NEXUS_HOME}/nexus-${NEXUS_VERSION}/bin/nexus.vmoptions

RUN echo "#!/bin/bash" >> ${NEXUS_HOME}/start-nexus-repository-manager.sh \
    && echo "cd /opt/nexus/nexus-${NEXUS_VERSION}" >> ${NEXUS_HOME}/start-nexus-repository-manager.sh \
    && echo "exec ./bin/nexus run" >> ${NEXUS_HOME}/start-nexus-repository-manager.sh \
    && chmod a+x ${NEXUS_HOME}/start-nexus-repository-manager.sh \
    && sed -e '/^nexus-context/ s:$:${NEXUS_CONTEXT}:' -i ${NEXUS_HOME}/nexus-${NEXUS_VERSION}/etc/nexus-default.properties

VOLUME /opt/nexus/sonatype-work

EXPOSE 18081
USER nexus

ENV INSTALL4J_ADD_VM_PARAMS="-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m -Djava.util.prefs.userRoot=/opt/nexus/sonatype-work/nexus3/javaprefs"

CMD ["/opt/nexus/nexus-3.37.3-02/bin/nexus", "run"]
