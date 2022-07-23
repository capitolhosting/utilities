#!/usr/bin/env bash

build-ffmpeg() {
    SKIPINSTALL=yes #variable that skips ffmpeg install, we just need the build, not the install on the CI box
    install_deps
    ffmpeg_compile
}


install_deps () {  # Function to check for package manager and install the correct build dependancies for ffmpeg
  YUM_CMD=$(which yum)
  DNF_CMD=$(which dnf)
  APT_GET_CMD=$(which apt)
  YAY_GET_CMD=$(which yay)
  PACMAN_GET_CMD=$(which pacman)
  if [[ ! -z ${YUM_CMD} ]]; then
    echo "Enterprise Linux Found! Using 'yum'"
    yum install -y \@Development\ Tools curl
  elif [[ ! -z ${DNF_CMD} ]]; then
    echo "Enterprise Linux Found! Using 'dnf'"
    dnf install -y \@Development\ Tools curl
  elif [[ ! -z ${APT_GET_CMD} ]]; then
    echo "Debian/Ubuntu Found! Using 'apt'"
    apt install -y build-essential curl
  elif [[ ! -z ${YAY_GET_CMD} ]]; then
    echo "Arch Linux/Manjaro Found! Using 'yay'"
    yay -Sy base-devel curl
  elif [[ ! -z ${PACMAN_GET_CMD} ]]; then
    echo "Arch Linux/Manjaro Found! Using 'pacman'"
    pacman -Sy base-devel curl
  else
    echo "error can't install required packages... Aborting!"
    exit 1;
  fi

}

ffmpeg_compile () { # Function to pull and compile ffmpeg from latest source
    mkdir /tmp/build
    cd /tmp/build
    bash <(curl -s https://raw.githubusercontent.com/markus-perl/ffmpeg-build-script/master/build-ffmpeg) --build --enable-gpl-and-non-free
    cd ./workspace/bin
    tar -czvf /tmp/ffmpeg/ffmpeg.tgz ffmpeg ffplay ffprobe
}


build-ffmpeg "${@}"
