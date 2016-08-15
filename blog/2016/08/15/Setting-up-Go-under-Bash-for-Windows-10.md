
# Exploring Bash for Windows 10 Pro

## Initital Setup and configuration

I am running Windows 10 Pro (64bit) Anniversary edition under Virtual Box. The VM was upgraded from an earlier version of Windows 10 Pro (64bit). After the upgrade I took the following steps

+ Search with Bing for "Bash for Windows" 
    + Bing returns http://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/
+ Switch on developer mode for Windows
+ Turned on Linux Subsystem Beta (searched for "Turning on Features")
+ Reboot
+ Search for "Bash" and clicked on "Run Bash command"
+ Answered "y"
+ Waited for download and extracted file system
+ When prompted setup developer account with username/password
    + Documentation can be found at https://aka.ms/wsldocs
+ Exit root install shell
+ Search for "Bash" local
+ Luanched "Bash on Ubuntu on Windows"

## Setting up Go under Bash for Windows 10

With Bash installed these are the steps I took to compile Go
under Bash on Ubuntu on Windows.

```shell
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get autoremove
    sudo apt-get install build-essential git-core unzip zip -y
    export CGO_ENABLED=0
    git clone https://github.com/golang/go go1.4
    git clone https://github.com/golang/go go
    cd go1.4
    git checkout go1.4.3
    cd src
    ./all.bash
    cd
    cd go
    git checkout go1.6.3
    cd src
    ./all.bash
    export PATH=$PATH:$HOME/go/bin:$HOME/bin
    export GOPATH=$HOME
```

If successful you should be able to install additional Go based software
with the usual `go get ...` syntax.



