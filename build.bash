#!/bin/bash

sudo apt-get install yasm libmp3lame-dev

git submodule update --init

export STATIC_CONFIG="--enable-static --disable-shared --prefix=/opt/media-tools"

export PKG_CONFIG_PATH=/opt/media-tools/lib/pkgconfig

for d in fdk-aac ogg vorbis flac opus
do
  pushd "$d" 
  [ -x ./autogen.sh ] && ./autogen.sh
  ./configure $STATIC_CONFIG
  make && make install
  popd
done

pushd x264
./configure $STATIC_CONFIG --disable-cli --disable-opencl
make && make install
popd

pushd libvpx
./configure $STATIC_CONFIG --enable-vp9
make && make install
popd

pushd ffmpeg
./configure $STATIC_CONFIG --enable-{gpl,nonfree,static,lib{fdk-aac,mp3lame,opus,vorbis,vpx,x264}} --extra-cflags=-I/opt/media-tools/include --extra-ldflags=-L/opt/media-tools/lib
make && make install
popd
