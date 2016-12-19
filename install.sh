#!/bin/bash

BINDIR="/usr/local/bin"
LIBDIR="/usr/local/lib"

# Create the minify directory
mkdir "$LIBDIR/minify"

# Download and compile zopfli & zopflipng
git clone https://github.com/google/zopfli.git
cd zopfli/
make zopfli
make zopflipng
cp zopfli zopflipng $BINDIR

# Install svgo 
npm install -g svgo

# Download and install jpegtran
cd ..
wget http://www.ijg.org/files/jpegsrc.v9b.tar.gz
tar -xzf jpegsrc.v9b.tar.gz
cd jpeg-9b/
./configure
make
cp jpegtran $BINDIR

# Download and install gifsicle
cd ..
git clone https://github.com/kohler/gifsicle.git
cd gifsicle/
./bootstrap.sh
./configure
make
cp src/gifsicle $BINDIR

# Download yuicompressor
wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar -O $LIBDIR/minify/yuicompressor-2.4.8.jar

# Install the minify command locally
cd ..
sed 's,LIBDIR,'"$LIBDIR"',' minify.txt > $BINDIR/minify
chmod +x $BINDIR/minify

# Clean up
echo "Cleaning up..."
rm -rf gifsicle/ jpeg-9b/ jpegsrc.v9b.tar.gz zopfli/
echo "Done."
