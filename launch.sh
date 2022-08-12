#!/bin/zsh
export GITDIR=/Users/${USER}/git/bitcoin
export BITCOIN_BUILDDIR=/Users/${USER}/bitcoin/builds
export BITCOIN_CHAIN=main
export BITCOIN_GIT_BRANCH=master
export BITCOIN_CONTEXT_ACTIVE=1
export BITCOIN_CHAINS=(main test regtest signet)


setbtccontext() {
    #Sets BITCOIN_CHAIN and BITCOIN_GIT_BRANCH
    eval $(python ./branch-manager.py context "$1")
}

bcbranch() {
    BITCOIN_GIT_BRANCH=$1
    set_alias
    PROMPT=$(bc_prompt)
}

bcchain() {
    BITCOIN_CHAIN=$1
    set_alias
    PROMPT=$(bc_prompt)
}

_network() {
    COMPREPLY=();
    local word="${COMP_WORDS[COMP_CWORD]}";
    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=($(compgen -W "testnet mainnet regtest" -- "$word"));
    else
        local words=("${COMP_WORDS[@]}");
        unset words[0];
        unset words[$COMP_CWORD];
        local completions=$(rbenv completions "${words[@]}");
        COMPREPLY=($(compgen -W "$completions" -- "$word"));
    fi
}

complete -F _network network

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
    if [[ ! -d $GITDIR/build/ ]]; then
        mkdir -p $GITDIR/build/
    fi
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
    alias bc="${BITCOIN_BUILDDIR}/${BITCOIN_GIT_BRANCH}/src/bitcoin-cli -chain=${BITCOIN_CHAIN}" #linux default bitcoind path
    alias bd="${BITCOIN_BUILDDIR}/${BITCOIN_GIT_BRANCH}/src/bitcoind -chain=${BITCOIN_CHAIN}" #linux default bitcoind path
    alias btcinfo='${BITCOIN_BUILDDIR}/${BITCOIN_GIT_BRANCH}/src/bitcoin-cli -chain=${BITCOIN_CHAIN} getwalletinfo | egrep "\"balance\""; bitcoin-cli -chain=${BITCOIN_CHAIN} getnetworkinfo | egrep "\"version\"|connections"; bitcoin-cli -chain=${BITCOIN_CHAIN} getmininginfo | egrep "\"blocks\"|errors"'

    #alias btcblock="echo $(bc getblockcount) /\ $(wget -O - https://blockstream.info/testnet/api/blocks/tip/height 2> /dev/null | cut -d : -f2 | rev | cut -c 1- | rev)"


    alias bcstart="${BITCOIN_BUILDDIR}/${BITCOIN_GIT_BRANCH}/src/bitcoind -chain=${BITCOIN_CHAIN} -daemon"
    alias bcstop="${BITCOIN_BUILDDIR}/${BITCOIN_GIT_BRANCH}/src/bitcoin-cli -chain=${BITCOIN_CHAIN} stop"
    alias bcrestart="bcstop; bcstart"
    alias bcconf="${BITCOIN_BUILDDIR}/${BITCOIN_GIT_BRANCH}/src/bitcoin-cli -chain=${BITCOIN_CHAIN} getinfo"

    alias bcdir="cd /Users/${USER}/Library/Application\ Support/Bitcoin" #maco default bitcoin path
    alias bcgit="cd /Users/${USER}/git/bitcoin"
    alias bcbuilddir="cd ${BITCOIN_BUILDDIR}/${BITCOIN_GIT_BRANCH}"



}

pull() {

}

exit() {
    $PROMPT=$OLD_PROMPT
}

bcreload() {
    #Reloads the current bitcoin environment

    CUR=$(pwd)
    cd /Users/${USER}/git/bitcoin-utils
    git pull
    source launch.sh
    cd $CUR
    setopt PROMPT_SUBST
    
} 

bcbranch_prompt() {


    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git -C $GITDIR rev-parse @)
    REMOTE=$(git -C $GITDIR rev-parse "$UPSTREAM")
    if [ $LOCAL = $REMOTE ]; then
        echo $fg[green]$BITCOIN_GIT_BRANCH$reset \> 
    else
        echo $fg[red]$BITCOIN_GIT_BRANCH$reset$fg[white] \> 
    fi

}

bcchain_prompt() {
    if [ $BITCOIN_CONTEXT_ACTIVE -eq 1 ]; then
        case $BITCOIN_CHAIN in 
            main)
                echo $fg[green]$BITCOIN_CHAIN$reset$fg[white] \>
                ;;
            test)
                echo $fg[yellow]$BITCOIN_CHAIN$reset$fg[white] \>
                ;;
            regtest)
                echo $fg[red]$BITCOIN_CHAIN$reset$fg[white] \>
                ;;
            *)
                echo $fg[blue]$BITCOIN_CHAIN$reset$fg[white] \>
                ;;
        esac
    fi
}

bc_prompt() {
    OLD_PROMPT=$PROMPT
    echo $fg[white]@%m%{$reset_color%} $(bcbranch_prompt) $(bcchain_prompt) %{$fg[cyan]%}%c%{$reset_color%} \> $fg[white]%\$ $reset_color
}
set_alias