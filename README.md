### gordonff/dev

Provides a Bash command line environment for java, scala and python development.

#### tag: latest

Use this image when troubleshooting modifications: volume mount points or sdk managed applications.

Use the timezone build parameter to set the timezone of the image to a value other than the "US/Pacific".

Building an image with a default build command in the default directory context

```powershell
  docker build -rm . 
```

is the same as

```powershell
  docker build -rm . --build-arg timezone="US/Pacific" 
```

when the default command line options are displayed as parameters. To build an image for another timezone, pass it is as build argument.

```powershell
  docker build -rm . --build-arg timezone="US/Eastern" -t gordonff/dev:edt 
```

to browse around in a `bash` shell as root

```powershell
  docker run -it --rm gordonff/dev
```

to mounting a host's directory as a data volume in a container
 
```powershell
  docker run --rm -it -v /c/tmp:/data gordonff/dev:latest
```

#### tag: user or how to use the latest tag   

maps a docker data container containing a users Linux home directory and the current host user's git directory to the /data  partition. The former allows for reuse of application configurations, while the later allows host based IDEs such as IntelliJ to execute this image interactively in the terminal window. Similar to using IntelliJ on Linux except there is no visible virtual machine and no VMWARE required. I also see this environment as similar to the Ubuntu Subsystem for Windows except that it is out of beta and more stable.

Here the default build command 
```powershell
  docker build -rm . 
```

expands to 

```powershell
  docker build -rm . --build-arg LOGIN=user 
```

with all of its defaults listed as parameters. Here is how to mount the user's home direcory as c:\tmp.

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
  network_mode: "bridge"
  stdin_open: true
  tty: true
  cap_add:
  - ALL
  container_name: dev_bob
```

Bring up the docker compose environment with the shell service but in detached mode as it's a service. Instead, attach to the shell instance after the docker-compose up command completes.
    _TODO_: add a web-link to here about this solution.

```powershell
  docker-compose up -d
  docker attach dev_bob
```
