#!/bin/bash

if [ ! -e /opt/media-tools ]
then
  sudo mkdir /opt/media-tools && sudo chown c /opt/media-tools
fi

git submodule update --init

export STATIC_CONFIG="--enable-static --disable-shared --prefix=/opt/media-tools"

for d in fdk-aac ogg vorbis flac opus
do
  pushd "$d" 
  [ -x ./autogen.sh ] && ./autogen.sh
  ./configure $STATIC_CONFIG
  make && make install
  popd
done

pushd x264
git checkout master && git pull
./configure $STATIC_CONFIG --disable-cli --disable-opencl
make && make install
popd

pushd libvpx
git checkout master && git pull
./configure $STATIC_CONFIG --enable-vp9
make && make install
popd

pushd ffmpeg
git checkout master && git pull
./configure $STATIC_CONFIG --enable-{gpl,nonfree,static,lib{fdk-aac,mp3lame,opus,vorbis,vpx,x264}} --extra-cflags=-I/opt/media-tools/include --extra-ldflags=-L/opt/media-tools/lib --disable-avcodec
make && make install
popd
