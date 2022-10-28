# Run this with super user administration
SOURCE_DIR=$(pwd)
export $(sudo env | grep SUDO)
USER_DIR=/home/"$SUDO_USER"
cd $USER_DIR

###################################################################################################
# Installing latest version of git
echo -ne '\n' | sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git -y 

###################################################################################################
# Docker
sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y 

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo groupadd docker
sudo usermod -aG docker $USER
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

###################################################################################################
# Installing Vim from source
sudo apt install make -y
sudo apt-get install build-essential -y
sudo apt-get install libncurses5-dev libncursesw5-dev -y
sudo apt-get update 
git clone https://github.com/vim/vim.git
cd vim/src
./configure
./make distclean
./make
./make install 
cd $USER_DIR
rm -rf vim
# Setting Vim as default editor for git
git config --global core.editor "vim"

###################################################################################################
# LSD Install
sudo apt-get install jq -y
latestVersion=$(curl -sL https://api.github.com/repos/Peltoche/lsd/releases/latest | jq -r ".tag_name")
fileName=lsd-musl_${latestVersion}_amd64.deb
wget https://github.com/Peltoche/lsd/releases/download/${latestVersion}/${fileName}
sudo dpkg -i $fileName
rm $fileName

###################################################################################################
# tmux 
sudo apt install tmux -y 
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

###################################################################################################
# Copying the configuration files to USER_DIR dir
cp -r "${SOURCE_DIR}"/config/. $USER_DIR
# tmux setting and installing plugins
tmux source ~/.tmux.conf
~/.tmux/plugins/tpm/scripts/install_plugins.sh
# Vim setting and installing plugins
# Plugin Manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'source ~/.vimrc' +'PlugInstall!' +'PlugUpdate!' +qa

###################################################################################################
# Installing Github Authenticator

type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install gh -y
sudo apt-get update
sudo apt install gh

###################################################################################################
# Bash Prompt 
# Comment: Haven't yet fully tested this section, nor have time for it now, will be implemented
#   in future. 
# sudo apt-get update
# sudo apt install fonts-powerline -y
# git clone --recursive https://github.com/andresgongora/synth-shell.git
# chmod +x synth-shell/setup.sh
# cd synth-shell
# ./setup.sh
