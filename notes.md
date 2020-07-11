Docker Ecosystem

- Docker Client (CLI)
- Docker Server (Daemon)
- Docker Machine
- Docker Images
- Docker Hub
- Docker Compose

Image

- single file with all dependencies and config to run a program

Kernel

- intermediate layer between programs and hard drive, CPU or memory
- programs (processes) talk to kernel via system call

Namespacing

- OS feature
- segment out portion of HD to house different versions of software (versions Python for eg)
- kernel will redirect to the correct namespace when segmentation is present
- isolate resources for a certain process

Control Groups

- limit the amount of resources per process
  - resources like memor, CPU usage etc

Container

- a process or set of process with namespaced resources for running it

Image

- filesystem snapshot with a startup command
  - snapshot of processes
