#!/bin/bash

git submodule update --init

for d in fdk-aac ogg vorbis flac opus
do
  pushd "$d" 
  [ -x ./autogen.sh ] && ./autogen.sh
  ./configure --enable-static --disable-shared
  make && sudo make install
  popd
done

pushd x264
./configure --enable-static --disable-shared --disable-cli --disable-opencl
make && sudo make install
popd

pushd libvpx
./configure --enable-static --disable-shared --enable-vp9
make && sudo make install
popd

pushd ffmpeg
./configure --disable-shared --enable-{gpl,nonfree,static,lib{fdk-aac,mp3lame,opus,vorbis,vpx,x264}}
make && sudo make install
popd
