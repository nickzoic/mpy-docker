# mpy-docker 

This is a work in progress.

There's two aims for this project:

1. Make a dockerized build system so people with Windows or OSX can build MicroPython
   from source without having to mess around with the build toolchain.

2. Make a *safe* build system for CI purposes, which can build peoples' 
   pull requests safely.

The two are related but perhaps not identical.  Because Makefiles and test files 
can contain arbitrary commands, we don't run them on the host system, only as an
unprivileged user on an ephemeral docker container with no network access!  

```
    ./run-in-docker.sh pull/37/head
```
