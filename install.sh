#!/bin/bash

BINDIR="/usr/local/bin"

# GIF manipulation
apt-get -qq install -y gifsicle > /dev/null

# JPG manipulation
apt-get -qq install -y libjpeg-turbo-progs > /dev/null

# PNG manipulation
apt-get -qq install -y pngcrush > /dev/null

# SVG optimization
apt-get -qq install -y npm > /dev/null
npm install --quiet --silent -g svgo > /dev/null 2>&1

# Zopfli (File compression)
apt-get -qq install -y zopfli > /dev/null

# YUI-compressor (JavaScript and CSS)
apt-get -qq install -y yui-compressor > /dev/null

# Install the minify command locally
chmod +x ./minify.sh
cp ./minify.sh $BINDIR/minify

echo "The 'minify' command has been copied to /usr/local/bin"
