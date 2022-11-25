# Automatic Development Workspace Setup

## Installed applications:
* Git 
* Docker
* Vim
* tmux
* LSD (LSDeluxe)
* Synth Shell

This script setups the working/development workspace including Vim and tmux settings and plugins.

Run the file:

`sudo chmod a+x setup.sh`

`./setup.sh` 

NOTE: Don't forget to run!

* Github authentication: `gh auth login`

* Docker login: `sudo docker login`

--------------------

To log:

`sh -x ./setup.sh >> logs.txt`
