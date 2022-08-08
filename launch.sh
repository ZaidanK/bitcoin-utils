#!/bin/zsh
export GITDIR=/Users/${USER}/git/bitcoin
export BITCOIN_BUILDDIR=/Users/${USER}/bitcoin/builds/
export BITCOIN_CHAIN=mainnet
export BITCOIN_GIT_BRANCH=master


setbtccontext() {
    #Sets BITCOIN_CHAIN and BITCOIN_GIT_BRANCH
    eval $(python ./branch-manager.py context "$1")
}

network() {
    export BITCOIN_
}

show_envar() {
    #Shows the current environment variables
    echo "GITDIR: $GITDIR"
    echo "BITCOIN_BUILDDIR: $BITCOIN_BUILDDIR"
    echo "BITCOIN_CHAIN: $BITCOIN_CHAIN"
    echo "BITCOIN_GIT_BRANCH: $BITCOIN_GIT_BRANCH"
}

configure() {
    cd $GITDIR
    make clean
    git clean -f -dX
    mkdir build
    cd build
    ../autogen.sh
    ../configure --without-bdb --without-gui
}

build() {
    configure()
    cd $GITDIR/build/
    make -j 8
    make check
    dirname=${BITCOIN_BUILDDIR}/${BITCOIN_GIT_BRANCH}
    echo "Moving to build directory:" $dirname
    mkdir -p "$dirname"
    mv -v /Users/${USER}/git/bitcoin/build/* "$dirname"/
    cd $dirname

}

set_alias() {
    alias btcdir="cd ~/.bitcoin/" #linux default bitcoind path
    alias bc="bitcoin-cli -chain=${BITCOIN_CHAIN}" #linux default bitcoind path
    alias bd="bitcoind -chain=${BITCOIN_CHAIN}" #linux default bitcoind path
    alias btcinfo='bitcoin-cli getwalletinfo | egrep "\"balance\""; bitcoin-cli -chain=${BITCOIN_CHAIN} getnetworkinfo | egrep "\"version\"|connections"; bitcoin-cli -chain=${BITCOIN_CHAIN} getmininginfo | egrep "\"blocks\"|errors"'

    alias bcstart="bitcoind -${BITCOIN_CHAIN} -daemon"
    alias bcstop="bitcoin-cli -${BITCOIN_CHAIN} stop"
    alias bcrestart="bitcoin-cli -${BITCOIN_CHAIN} stop; bitcoind -${BITCOIN_CHAIN} -daemon"
    alias bcconf="bitcoin-cli -${BITCOIN_CHAIN} getinfo"

    alias bcdir="cd /Users/${USER}/Library/Application Support/Bitcoin" #maco default bitcoin path
    alias bcgit="cd /Users/${USER}/git/bitcoin"



}

pull() {

}

exit() {

}

set_alias