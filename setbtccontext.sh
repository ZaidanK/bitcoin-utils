#!/bin/zsh
CWD=${pwd}

export GITDIR=/Users/${USER}/git/bitcoin
export BUILDDIR=/Users/${USER}/bitcoin/builds/
echo $1
IFS=':'
ARG=$1
a=(${ARG})
NETWORK=test
export BRANCH=${a[0]}
export NETWORK=${a[1]}

cd $GITDIR
#select what branch
# branches=()
# eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/heads/)"
# select opt in "${branches[@]}"
# do
#     echo "You picked $opt ($REPLY)"
#     SELECTED=$(echo "$opt" | sed 's#refs/heads/##g')
#     echo $SELECTED
#     git checkout $SELECTED
#     break;
# done

# OLD_PROMPT=$PROMPT
# PROMPT=" (${NETWORK}) ${SELECTED} %1~ %# "






mkdir build
cd build
../autogen.sh
../configure --without-bdb --without-gui


#echo "Building..."
make -j 8

make check
echo "Moving to build directory:" $dirname
cd /Users/${USER}/git/bitcoin
dirname=/Users/${USER}/bitcoin/builds/${SELECTED}
echo "$dirname"/
mv -v /Users/${USER}/git/bitcoin/build/* "$dirname"/
cd $dirname


