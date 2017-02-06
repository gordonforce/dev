### gordonff/dev

#### tags

- v2.0 latest user: [Dockerfile](https://github.com/gordonforce/dev/blob/latest/Dockerfile)
[![](https://images.microbadger.com/badges/image/gordonff/dev.svg)](https://microbadger.com/images/gordonff/dev "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/gordonff/dev.svg)](https://microbadger.com/images/gordonff/dev "Get your own version badge on microbadger.com")
- v1.0 [Dockerfile](https://github.com/gordonforce/dev/blob/v1.0/Dockerfile)

##### Version 2.0 Release Notes

Changed the base image to ubuntu:16.04 from debian:latest as the later would no longer provide a java command when invoked with /bin/bash. The docker hub page for the Debian latest image states the automated build is broken; hence, I might switch back to it later. The remaining changes were made while using version 1.0.

- Added the directories /src and /dest as mount points when scripting one off maintenance tasks such as Docker volume backups.
    - Note: I often use the /src mount point as the share point between this docker image's container and the host managed git directory. The /dest mount point remains free for some random task or dangle.

- Moved timezone from a build parameter to the TZ environment variable settable from a docker-compose file.

- Changed OpenSSH-server package to OpenSSH-client as I never used the former but I do use the later.

- Removed the docker_entrypoint.sh script and declaration from the Dockerfile the invoking the bash command shell with `CMD` provides sufficient services.

##### Version 1.0 Release Notes

Provides a Bash command line environment for Java, Scala and Python development suitable for an Intellij Terminal on Windows 10.

#### tag: latest

Use this image when troubleshooting modifications, for example, volume mount points or new applications, as root.
Here is how to build the latest image and use it.

```powershell
  docker build -rm . 
```

to browse around in a `bash` shell as root

```powershell
  docker run -it --rm gordonff/dev /bin/bash
```

to mounting a host's directory as a data volume in a container and list the directories contents.
 
```powershell
  docker run --rm -it -v /c/tmp:/ gordonff/dev:latest /bin/bash -c "ls /src/.* /src/*"
```

#### tag: user or how to use the latest tag   

Maps a docker data container containing a users Linux home directory and the current host user's git directory to the /src partition. The former allows for reuse of application configurations, while the later allows host-based IDEs such as IntelliJ to execute this image interactively in the terminal window. Similar to using IntelliJ on Linux except there is no visible virtual machine and no VMWARE required. I also see this environment as close to the Ubuntu Subsystem for Windows except that it is out of beta and more stable.

Use _LOGIN_ build parameter to set the username to a value other than `user`. Here the default build command to use.
```powershell
  docker build -rm . 
```
expands to 

```powershell
  docker build -rm . --build-arg LOGIN=user
```

with all of its defaults listed as parameters. Here is how to mount the user's home directory as c:\tmp.

```powershell
    docker run --rm -it gordonff/dev:user -v /c/tmp:/home/user 
```

here is how to do the same thing for someone with the username bob

```powershell
    docker build -t gordonff/dev:latest --build-arg LOGIN="bob" 
```

Here is an example of building and running the image using `docker-compose`

```yaml
version "3.0"

services:
...
  shell:
    cap_add:
    - ALL
    container_name: dev_bob
    environment:
    - LOGIN=bob
    - TZ=US/Pacific
    image: gordonff/dev:bob
    network_mode: "host"
    stdin_open: true
    tty: true
    volumes:
    - home_bob:/home/bob:rw
    - c:/Users/bob/git:/src:rw
...
volumes:
  home_bob:
...
```

Bring up the docker-compose environment with the shell service in _detached_ mode as it's a service. Instead, attach to the shell instance after the docker-compose up command completes.

```powershell
  docker-compose up -d
  docker attach dev_bob
```
