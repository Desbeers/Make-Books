#!/bin/zsh

### This file is included in the beginning of all other scrips.

### VARIABLES

# The base directory of this build system:
# See man zshexpn
local="${0:a:h:h}"

gui="cmd"

# Overrule config from command line
zparseopts -E -D -gui:=g -paper:=p -font:=f -export:=e -books:=b -lang:=l
if [[ -n $g ]]; then gui=${g[2]} fi
if [[ -n $p ]]; then papersize=${p[2]} fi
if [[ -n $f ]]; then fontsize=${f[2]} fi
if [[ -n $e ]]; then export=${e[2]} fi
if [[ -n $b ]]; then books=${b[2]} fi
if [[ -n $l ]]; then lang=${l[2]} fi
# Preserve config with spaces in directory names.
config=(--gui $gui --paper $papersize --font $fontsize --export $export --books $books --lang $lang)

# Configuration:

# If running from the command line we load the configuration file
# If the script is started by a GUI; that GUI has to take care of the config
if [[ $gui == "cmd" ]]; then
    echo "Loading config.zsh"
    if [[ -f $HOME/.config/make-books/config.zsh ]]; then
    echo "Using local configuration." >&2
    . $HOME/.config/make-books/config.zsh
    else
    echo "Using system configuration." >&2
    . $local/config.zsh
    fi
fi
export GUI=$gui

# Include some nice colours for the termnal output:
. $local/includes/colours.zsh

# Build dir
export TMPBOOKS="$HOME/.cache/make-books"

# Create dir if needed
mkdir -p $TMPBOOKS

# Logging
start_log() {
    if [[ ! -v SCRIPT ]]; then
        export SCRIPT=$1
        start=`date +%s`
    fi
}

stop_log() {
    sleep 0.5
    if [[ $SCRIPT = $1 && $GUI = "cmd" ]]; then
        end=`date +%s`
        echo "  End logging: it took $((end-start)) seconds."
    fi
}

### SHARED FUNCTIONS

# Parse metadata
metadata() {
    echo ${$(grep "^$1:" $2 | sed -e "s/^$1: *//")}
}

# Get book position in collection
get_collection_position() {
    [[ $2 =~ $1'=([^;]+)' ]]
    echo $match[1]
}

# Make strings 'safe', replace spaces and other funny characters
safe_string() {
    echo ${1//[ .&]/-}
}
