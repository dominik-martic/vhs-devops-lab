# Sonatype Nexus

Guide to run Nexus instance using Podman inside of the ubi8.7 OS image.

## Installation

Use Podman to create isolated containerized instance of Nexus.

```bash
# Rocky Linux
sudo dnf install podman -y
```

## Usage

Build and run container image from root directory of the project:

```bash
sudo mkdir -p /tn_devops/nexus
sudo chown $USER:$USER -R /tn_devops
podman unshare chown 200:200 -R /tn_devops

# Build the image from Dockerfile
./build_image.sh

# Start the container from built image
./run.sh

# Initial password for the admin user
cat $(pwd)/tn_devops/nexus/nexus3/admin.password

# Run container at startup of Rocky Linux
podman generate systemd --name nexus > nexus.service
sudo mv nexus.service /usr/lib/systemd/system/nexus.service
systemctl enable nexus
```

After going through all of the steps you should have your containerized instance up and running.
Login at http://localhost:18081/nexus/ with username "admin" and the inital password
that we found in the code block above, after that amin.password file is deleted.

