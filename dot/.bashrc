#!/bin/bash
# bashrc
#

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

. ~/.aliases

PS1='[\u@\h \W]\$ '
