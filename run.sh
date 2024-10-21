#!/bin/bash

podman run -d --name nexus -p 18081:8081 -v $(pwd)/tn_devops/nexus/:/opt/nexus/sonatype-work localhost/nexus

echo -e "\n Nexus starting @ http://localhost:18081/nexus/"
