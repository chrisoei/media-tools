#!/bin/bash

git submodule update --init

export STATIC_CONFIG="--enable-static --disable-shared --extra-ldflags=-static"

for d in fdk-aac ogg vorbis flac opus
do
  pushd "$d" 
  [ -x ./autogen.sh ] && ./autogen.sh
  ./configure $STATIC_CONFIG
  make && sudo make install
  popd
done

pushd x264
./configure $STATIC_CONFIG --disable-cli --disable-opencl
make && sudo make install
popd

pushd libvpx
./configure $STATIC_CONFIG --enable-vp9
make && sudo make install
popd

pushd ffmpeg
./configure $STATIC_CONFIG --enable-{gpl,nonfree,static,lib{fdk-aac,mp3lame,opus,vorbis,vpx,x264}}
make && sudo make install
popd
