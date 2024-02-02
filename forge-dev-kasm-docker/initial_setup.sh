#!/bin/bash
echo "This is a script to build a containerized forge-dev like environment using KasmVNC."
echo "The apps included in the container are: forge-desktop-SNAPSHOT, Tiled - Map Editor and MagicSetEditor2."
echo "....Initial_setup,...Now updating/upgrading container and installing additional pkgs."
sudo apt update; apt upgrade -y; apt install -y cmake wget nano bzip2 openjdk-11-jdk jq cmake fuse g++ gcc libboost-dev libboost-all-dev libwxgtk3.0-gtk3-dev libhunspell-dev build-essential checkinstall git
sudo apt autoremove -y

echo "INSTALLING MagicSetEditor2"

sudo git clone https://github.com/MagicSetEditorPacks/Full-Magic-Pack.git /app/mse/mse-full-pack

sudo git clone https://github.com/twanvl/MagicSetEditor2.git /app/mse/MagicSetEditor2
cd /app/mse/MagicSetEditor2
sudo cmake build -DCMAKE_BUILD_TYPE=Release
sudo cmake /app/mse/MagicSetEditor2/CMakeLists.txt
sudo make -f /app/mse/MagicSetEditor2/Makefile


sudo mkdir /config/.fonts
sudo mkdir /config/.magicseteditor
sudo mkdir /config/.magicseteditor/data
sudo mkdir /config/.magicseteditor/resource

sudo mv /app/mse/MagicSetEditor2/magicseteditor /config/.magicseteditor

sudo mv /app/mse/mse-full-pack/data/* /config/.magicseteditor/data
sudo mv /app/mse/mse-full-pack/Magic\ -\ Fonts/* /config/.fonts
sudo mv /app/mse/mse-full-pack/backup/resource/* /config/.magicseteditor/resource

sudo rm -rf /app/mse
#sudo rm -rf /app/mse/MagicSetEditor2

echo "INSTALLING Tiled - Map Editor"
sudo mkdir /app/tiled
cd /app/tiled
sudo wget https://github.com/mapeditor/tiled/releases/download/v1.10.2/Tiled-1.10.2_Linux_Qt-6_x86_64.AppImage
sudo chmod +x Tiled-1.10.2_Linux_Qt-6_x86_64.AppImage
sudo ./Tiled-1.10.2_Linux_Qt-6_x86_64.AppImage --appimage-extract
sudo rm Tiled-1.10.2_Linux_Qt-6_x86_64.AppImage

echo "REMOVING ANY OLD FORGE FILES"
sudo rm -rf /app/forge
sudo mkdir /app/forge
cd /app/forge

echo "DOWNLOADING LATEST FORGE-DEKSTOP-SNAPSHOT"
sudo wget -r -l1 -np "https://downloads.cardforge.org/dailysnapshots/" -A "forge-gui-desktop-*.tar.bz2"
sudo mv downloads.cardforge.org/dailysnapshots/*.tar.bz2 /app/forge
sudo rm -rf downloads.cardforge.org/dailysnapshots/old downloads.cardforge.org/ downloads.cardforge.org/dailysnapshots/ downloads.cardforge.org
echo "EXTRACTING FILES PLEASE WAIT, THIS WILL TAKE SOME TIME..."
sudo bzip2 -d *.tar.bz2
sudo tar -xf *.tar
sudo rm *.tar
sudo chmod +x *.sh
sudo mkdir /app/forge-desktop-update
sudo touch /app/forge-desktop-update/forge-dev-kasm-docker.sh
echo '#!/bin/bash
echo "REMOVING OLD FORGE FILES"
sudo rm -rf /app/forge
sudo mkdir /app/forge
cd /app/forge
echo "DOWNLOADING LATEST FORGE-DEKSTOP-SNAPSHOT"
sudo wget -r -l1 -np "https://downloads.cardforge.org/dailysnapshots/" -A "forge-gui-desktop-*.tar.bz2"
sudo mv downloads.cardforge.org/dailysnapshots/*.tar.bz2 /app/forge
sudo rm -rf downloads.cardforge.org/dailysnapshots/old downloads.cardforge.org/ downloads.cardforge.org/dailysnapshots/ downloads.cardforge.org
echo "EXTRACTING FILES PLEASE WAIT, THIS WILL TAKE SOME TIME..."
sudo bzip2 -d *.tar.bz2
sudo tar -xf *.tar
sudo rm *.tar
sudo chmod +x *.sh' |  cat - /app/forge-desktop-update/forge-dev-kasm-docker.sh > temp && mv temp /app/forge-desktop-update/forge-dev-kasm-docker.sh

echo "CREATING forge-dev-kasm-docker.sh"
sudo touch /config/forge-dev-kasm-docker.sh 
echo '#!/bin/bash
PS3='Choose One: '
forge=("Play Forge-Desktop-SNAPSHOT" "Play Forge-Adventure" "To update Forge-Desktop-SNAPSHOT" "Run MagicSetEditor2" "Run Tiled - Map Editor" "Quit")
select fav in "${forge[@]}"; do
    case $fav in
        "Play Forge-Desktop-SNAPSHOT")
            /app/forge/forge.sh
	    # optionally call a function or run some code here
            ;;
        "Play Forge-Adventure")
            /app/forge/forge-adventure.sh
	    # optionally call a function or run some code here
            ;;
        "To update Forge-Desktop-SNAPSHOT")
            /app/forge-desktop-update/update-forge-gui-desktop-SNAPSHOT.sh
            echo "UPDATE COMPLETE"
            /config/forge-dev-kasm-docker.sh
	    # optionally call a function or run some code here
        	;;
        "Run MagicSetEditor2")
            /config/.magicseteditor/magicseteditor
            ;;
        "Run Tiled - Map Editor")
           /app/tiled/squashfs-root/AppRun
        break
           ;;
	"Quit")
	    echo " Thank you for using forge-dev using KasmVNC"
	    exit
	    ;;
       *) echo "invalid option $REPLY";;
    esac
done' | cat - /config/forge-dev-kasm-docker.sh > temp && mv temp /config/forge-dev-kasm-docker.sh

sudo chmod +x /config/forge-dev-kasm-docker.sh

echo "Setup complete"
echo "To start forge-dev environment run: bash forge-dev-kasm-docker.sh"
