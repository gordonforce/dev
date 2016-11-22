### gordonff/dev

Provides a Bash command line environment for Java, Scala and Python development suitable for an IntelliJ Terminal on Windows 10.

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
  docker run --rm -it -v /c/tmp:/data gordonff/dev:latest /bin/bash -c "ls /data/.* /data/*"
```

#### tag: user or how to use the latest tag   

Maps a docker data container containing a users Linux home directory and the current host user's git directory to the /data partition. The former allows for reuse of application configurations, while the later allows host-based IDEs such as IntelliJ to execute this image interactively in the terminal window. Similar to using IntelliJ on Linux except there is no visible virtual machine and no VMWARE required. I also see this environment as close to the Ubuntu Subsystem for Windows except that it is out of beta and more stable.

Use the _timezone_ build parameter to set the image's timezone to a value other than `"US/Pacific"` and the _LOGIN_ build parameter to set the username to a value other than `user`. Here the default build command to use. 
```powershell
  docker build -rm . 
```
expands to 

```powershell
  docker build -rm . --build-arg LOGIN=user, timezone="US/Pacific" 
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
shell:
  build:
    image: gordonff/dev:bob
    args:
    - LOGIN=bob
  environment:
  - LOGIN=bob
  volumes_from:
  - container:bobhome:rw
  volumes:
  - c:/Users/bob/git:/data:rw
  network_mode: "host"
  stdin_open: true
  tty: true
  cap_add:
  - ALL
  container_name: dev_bob
```

Bring up the docker compose environment with the shell service but in detached mode as it's a service. Instead, attach to the shell instance after the docker-compose up command completes.

```powershell
  docker-compose up -d
  docker attach dev_bob
```
