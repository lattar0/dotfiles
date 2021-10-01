#!/usr/bin/env bash

usage() {
  cat <<EOF
usage: ${0##*/} [flags]
  Options:
    --install,  -i  Install everything
    --help,     -h  Show help
EOF
}

if [[ -z $1 || $1 = @(-h|--help) ]]; then
  usage
  exit $(( $# ? 0 : 1 ))
fi

_backup(){
if [[ -d ~/.config ]]
then
   cp -r ~/.config ~/.config-backup && echo "[info] if ~/.config exists, backup will be made"
fi
}

_mv(){
sudo rm -rf ~/.config
mv config .config && cp -r .config ~/ && mv .xmonad ~/ && mv .xmobarrc ~/
}

_yay(){
    sudo pacman -S git --noconfirm --needed && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd ..
}

_pkgs(){
sudo pacman -S alacritty fish rofi xmonad xmobar dunst feh neovim noto-fonts pulseaudio pavucontrol flameshot xorg-server discord less man --needed --noconfirm && yay -S nvidia-340xx-dkms

_post(){
chsh $USER --shell /bin/fish
}


_confirm(){
echo ""
echo -n "Do you want to continue? If yes, press enter "
read
clear
}

_install(){
reset
_confirm
_backup
_mv
_yay
_pkgs
_post
}

while [[ "$1" ]]; do
  case "$1" in
    "--install"|"-i") _install ;;
    "--help"|"-h") usage ;;
    *) echo 'Invalid option.' && usage && exit 1 ;;
  esac
  shift
done