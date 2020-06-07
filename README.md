Docker CUPSD
============
The Dockerfile and docker-compose.yaml file included in this repository create and run a simple Fedora based container for running CUPS. The main goal is to provide a print daemon that runs in a container to provide network access to a USB attached printer.

I ended up running this container image in priviledged mode because I couldn't figure out what needed to be mapped into the container to provide access to the USB device. Using the `--device` option did not work. Please file an issue if you know how to fix that.

The project is hosted in the following github project: https://github.com/elliotpeele/docker-cupsd

# Running

The latest build of the image is available from dockerhub.

`docker run -p 631:631 --priviledged --name cupsd elliotpeele/cupsd`

## Login
Go to http://localhost:631, click on Administration -> Add Printer
- Username: cupsadm
- Password: cupsadm

