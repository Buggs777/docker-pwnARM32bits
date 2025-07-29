# docker-pwnARM32bits
A basic ARM 32bits docker image to pwn root-me challenges
## Quick start
```bash
docker build -t arm-pwn .
docker run --rm -it -v "$PWD:/challenges" arm-pwn
