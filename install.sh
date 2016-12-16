#!/bin/bash

PWD=`pwd`
INSTALL_PATH="/minify"

# Create the minify directory
mkdir $INSTALL_PATH

# Download and compile zopfli / zopflipng
cd $PWD
git clone https://github.com/google/zopfli.git
cd zopfli/
make zopfli
make zopflipng
cp zopfli zopflipng $INSTALL_PATH

# Install svgo 
npm install -g svgo

# Download and install jpegtran
cd $PWD
wget http://www.ijg.org/files/jpegsrc.v9b.tar.gz
tar -xzf jpegsrc.v9b.tar.gz
cd jpeg-9b/
./configure
make
cp jpegtran $INSTALL_PATH

# Download and install gifsicle
cd $PWD
git clone https://github.com/kohler/gifsicle.git
cd gifsicle/
./bootstrap.sh
./configure
make
cp src/gifsicle $INSTALL_PATH

# Download yuicompressor
wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar -O $INSTALL_PATH/yuicompressor-2.4.8.jar

# Install the minify command locally
cd $PWD
sed 's,INSTALL_PATH,'"$INSTALL_PATH"',' minify.txt > $INSTALL_PATH/minify.sh
chmod +x $INSTALL_PATH/minify.sh
ln -s $INSTALL_PATH/minify.sh /usr/local/bin/minify

# Clean up
echo "Cleaning up..."
cd $PWD
rm -rf gifsicle/ jpeg-9b/ jpegsrc.v9b.tar.gz zopfli/
