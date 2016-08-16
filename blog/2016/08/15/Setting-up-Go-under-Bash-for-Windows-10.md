
# Exploring Bash for Windows 10 Pro

## Initital Setup and configuration

I am running Windows 10 Pro (64bit) Anniversary edition under Virtual Box. The VM was upgraded from an earlier version of Windows 10 Pro (64bit). The VM was allocated 4G or ram, 200G disc and simulating 2 cores.  After the upgrade I took the following steps

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
+ Search for "Bash" locally
+ Luanched "Bash on Ubuntu on Windows"
+ Authenticate with your username/password


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
    export PATH=$PATH:$HOME/go1.4/bin
    cd go
    git checkout go1.7
    cd src
    ./all.bash
    cd
    export PATH=$HOME/go/bin:$HOME/bin:$PATH
    export GOPATH=$HOME
```

Note some tests failing during compilation in both 1.4.3 and 1.7. They mostly failed
around network sockets.  This is probably a result of the limitations in the Linux subsystem
under Windows.

If successful you should be able to run `go version` as well as install additional Go based software
with the usual `go get ...` syntax.

In your `.bashrc` or `.profile` add the following

```shell
    export PATH=$HOME/go/bin:$HOME/bin:$PATH
    export GOPATH=$HOME
```


## Improved vim setup

I like the vim-go packages for editing Go code in vim. They are easy to setup.

```shell
     mkdir -p ~/.vim/autoload ~/.vim/bundle 
     curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
     git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
```

Example $HOME/.vimrc

```vimrc
    execute pathogen#infect()
    syntax on
    filetype plugin on
    set ai
    set nu
    set smartindent
    set tabstop=4
    set shiftwidth=4
    set expandtab
    let &background = ( &background == "dark"? "light" : "dark" )
    let g:vim_markdown_folding_disabled=1
```

Color schemes are browsable at [vimcolors.com](http://vimcolors.com). They can be installed in
$HOME/.vim/colors.

1. git clone and place the colorscheme
2. place the *.vim file holding the color scheme into $HOME/.vim/colors
3. start vim and at the : do colorscheme NAME where NAME is the scheme you want to try

You can find the default shipped color schemes in /usr/share/vim/vimNN/colors where vimNN is the version number
e.g. /usr/share/vim/vim74/colors.


