# Run this with super user administration
SOURCE_DIR=$(pwd)
cd $HOME

###################################################################################################
# Installing git
apt-get update 
apt-get install git -y 

###################################################################################################
# Docker
apt-get remove docker docker-engine docker.io containerd runc -y
apt-get update
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y 

DIR=/etc/apt/keyrings
if [ -d "$DIR" ];
then
    echo "$DIR directory exists."
else
    mkdir -p /etc/apt/keyrings 
	echo "$DIR directory does not exist, creating it."
fi

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
groupadd docker
usermod -aG docker $USER

###################################################################################################
# Installing Vim from source
apt install make -y
apt-get install build-essential -y
apt-get install libncurses5-dev libncursesw5-dev -y
apt-get update 
git clone https://github.com/vim/vim.git
cd vim/src
./configure
./make distclean
./make
./make install 
cd $HOME
rm -rf vim
# Plugin Manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \\
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

###################################################################################################
# tmux 
apt install tmux -y 
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

###################################################################################################
# Copying the configuration files to HOME dir
cp "${SOURCE_DIR}"/config/. $HOME
# Setting and installing plugins
tmux source ~/.tmux.conf
~/.tmux/plugins/tpm/scripts/install_plugins.sh

###################################################################################################
# LSD Install
apt-get install jq -y
latestVersion=$(curl -sL https://api.github.com/repos/Peltoche/lsd/releases/latest | jq -r ".tag_name")
fileName=lsd-musl_${lv}_amd64.deb
wget https://github.com/Peltoche/lsd/releases/download/${latestVersion}/${fileName}
dpkg -i $fileName