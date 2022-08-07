#!/bin/zsh

setbtccontext() {
    source /Users/${USER}/git/bitcoin-utils/setbtccontext.sh "$1"
}

build() {

}



pull() {

}

exit() {

}


alias btcdir="cd ~/.bitcoin/" #linux default bitcoind path

alias bcstart="bitcoind ${NETWORK} -daemon"
alias btcinfo='bitcoin-cli getwalletinfo | egrep "\"balance\""; bitcoin-cli getnetworkinfo | egrep "\"version\"|connections"; bitcoin-cli getmininginfo | egrep "\"blocks\"|errors"'
