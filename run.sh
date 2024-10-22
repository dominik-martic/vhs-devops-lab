#!/bin/bash

podman run -d --name nexus -p 18081:8081 -v /tn_devops/nexus:/opt/nexus/sonatype-work:Z localhost/nexus

echo -e "\n Nexus starting @ http://localhost:18081/nexus/"

# Run container at startup of Rocky Linux
podman generate systemd --name nexus > nexus.service
mkdir -p ~/.config/systemd/user/
mv nexus.service ~/.config/systemd/user/nexus.service
systemctl --user enable nexus.service

