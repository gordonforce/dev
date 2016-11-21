## gordonff/dev

Provides shell access to the latest Linux command line development 
tools such as java, scala, python and etc.  

### latest

Use this image when troubleshooting modifications: volume 
mount points or sdk managed applications.

Use the timezone build parameter to set the timezone of the image to a
value other than the "US/Pacific".

#### examples

**browse around in a bash shell as root**
```bash
docker run -it --rm gordonff/dev:debug
```

**test a host mounted data volume** 
```bash
docker run --rm -it -v /c/tmp:/data gordonff/dev:debug
```

### user   

maps a docker data container containing a users Linux home
directory and the current host user's git directory to the /data 
partition. The former allows for reuse of application configurations,
while the later allows host based IDEs such as IntelliJ to execute this 
image interactively in the terminal window. Similar to using IntelliJ 
on Linux except there is no visible virtual machine and no VMWARE 
required. I also see this environment as similar to the Ubuntu 
Subsystem for Windows except that it is out of beta and more stable.

```bash
docker run --rm -it gordonff/dev:user -v /c/somelocalpath:/home/user 
```

If using docker-compose on a Windows 10 host, the type of hosts 
will affect the content of the volumes host mount url. The equivalent 
for a linux system would be `/home/bob/git:/data`. 
 
```yaml
  shell:
    build:
      image: gordonff/dev:latest
      args:
      - LOGIN=user
    environment:
    - LOGIN=bob
    volumes_from:
    - container:userhome:rw
    volumes:
    - c:/Users/SomeUser/git:/data:rw
    network_mode: "bridge"
    stdin_open: true
    tty: true
    cap_add:
    - ALL
    container_name: dev_user
    
```

Bring up the docker compose environment with shell service but in
detached mode as services map the stdin and logs to a different location 
than when using the run command. Instead, attach to the shell instance 
after the docker-compose up command completes.

__TODO__: add a web-link to here about this solution.

```powershell
docker-compose up -d
docker attach bob_dev_latest
```


### building images

The build.py script builds the images using the docker shell 
commands. 

**defaults as command line arguments**

```bash
docker build -t gordonff/dev:debug  .
docker build -t gordonff/dev:latest . 
```
are equivalent to 

```bash
docker build -t gordonff/dev:debug --build-arg timezone="US/Pacific" .
docker build -t gordonff/dev:latest --build-arg LOGIN="whale_hugger" 
```
NOTE: whale_hugger means Docker Fan

**custom timezone and username for an east coast slacker**

```bash
docker build -t gordonff/dev:debug --build-arg timezone="US/Eastern" .
docker build -t gordonff/dev:latest --build-arg LOGIN="dude" 
```

**most common use case envisioned for west coast bob**

```bash
docker build -t gordonff/dev:latest --build-arg LOGIN="bob" 
```

**docker-compose snippet**
see the docker compose code block about as it contains build commands.