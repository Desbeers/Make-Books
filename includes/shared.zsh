#!/bin/zsh

### This file is included in the beginning of all other scrips.

### VARIABLES

# The base directory of this build system:
# See man zshexpn
local="${0:a:h:h}"

# Configuration file:
if [[ -f $HOME/.config/make-books/config.zsh ]]; then
    #echo "Using local configuration." >&2
    . $HOME/.config/make-books/config.zsh
else
    #echo "Using system configuration." >&2
    . $local/config.zsh
fi

# Overrule config from command line
zparseopts -E -D -paper:=p -font:=f -export:=e -books:=b
if [[ -n $p ]]; then papersize=${p[2]} fi
if [[ -n $f ]]; then fontsize=${f[2]} fi
if [[ -n $e ]]; then export=${e[2]} fi
if [[ -n $b ]]; then books=${b[2]} fi
# Preserve config with spaces in directory names.
config=(--paper $papersize --font $fontsize --export $export --books $books)

# Include some nice colours for the termnal output:
. $local/includes/colours.zsh

# Build dir
export TMPBOOKS="$HOME/.cache/make-books"

# Log files
export LOGFILE=$TMPBOOKS'/log.txt'
export JSLOGFILE=$TMPBOOKS'/jslog.js'

# Create dir and files if needed
mkdir -p $TMPBOOKS
touch $LOGFILE
touch $JSLOGFILE

# Logging
start_log() {
    if [[ ! -v SCRIPT ]]; then
        export SCRIPT=$1
        echo "Start making..." > $LOGFILE
        echo 'var logging = true;' > $JSLOGFILE
        echo 'var log = "<p>'$PANDOC_ACTION's are on there way!</p>";' >> $JSLOGFILE
        # echo > $LOGFILE
        start=`date +%s`
    fi
}

stop_log() {
    if [[ $SCRIPT = $1 ]]; then
        end=`date +%s`
        echo "End logging: it took $((end-start)) seconds." >> $LOGFILE
        echo 'log += "<p>'$PANDOC_ACTION's are done: it took '$((end-start))' seconds.</p>";' >> $JSLOGFILE
        echo 'var logging = false;' >> $JSLOGFILE
    else
        #echo > $LOGFILE
    fi
}

### SHARED FUNCTIONS

# Parse metadata
metadata() {
    echo ${$(grep "^$1:" $2 | sed -e "s/^$1: *//")}
}

# Make strings 'safe', replace spaces and other funny characters

safe_string() {
    echo ${1//[ .&]/-}
}
