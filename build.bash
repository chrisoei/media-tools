#!/bin/bash

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

