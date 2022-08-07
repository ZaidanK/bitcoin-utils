#!/bin/bash
echo "Creating build directory..."
cd /Users/${USER}/git/bitcoin
dirname=/Users/${USER}/bitcoin/builds/`git rev-parse --abbrev-ref HEAD`
mkdir -p $dirname

echo "Configuring..."
cd /Users/${USER}/git/bitcoin
mkdir build
cd build
../autogen.sh
../configure --without-bdb --without-gui

#echo "Building..."
make -j 8

make check
echo "Moving to build directory:" $dirname
cd /Users/${USER}/git/bitcoin
dirname=/Users/${USER}/bitcoin/builds/`git rev-parse --abbrev-ref HEAD`
echo "$dirname"/
mv -v /Users/${USER}/git/bitcoin/build/* "$dirname"/
cd $dirname

echo "Setting up Bitcoin..."
#create bitcoin configuration file
#mkdir -p "/Users/${USER}/Library/Application Support/Bitcoin"
#touch "/Users/${USER}/Library/Application Support/Bitcoin/bitcoin.conf"
#chmod 600 "/Users/${USER}/Library/Application Support/Bitcoin/bitcoin.conf"

#export to path variable
#echo "Exporting to path variable..."
#echo -n 'export PATH="/Users/${USER}/git/bitcoin/build/src:$PATH"' >> ~/.zshrc
#source ~/.zshrc

