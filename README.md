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
mkdir -p $(pwd)/tn_devops/nexus/

# To be able to use volume from host, 200 is UID of nexus user
sudo chown 200:200 -R $(pwd)/tn_devops/nexus/

# Build the image from Dockerfile
./build_image.sh

# Start the container from built image
./run.sh

# Initial password for the admin user
cat $(pwd)/tn_devops/nexus/nexus3/admin.password
```

After going through all of the steps you should have your containerized instance up and running.
Now you can login at http://localhost:18081/nexus/ with username "admin" and the inital password 
that we found in the previous code block.

