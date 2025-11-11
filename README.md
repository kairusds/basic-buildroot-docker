# basic-buildroot-docker
Basic Docker development image for Buildroot

```
# Basic container
sudo docker run -it --privileged \
  --name buildroot \
  -v ./build:/build/output \
  kairusds/buildroot-builder:latest

# Start again and begin interactive mode if exited
sudo docker start -ai buildroot
```