#!/bin/bash
# bashrc
#

if [[ $- != *i* ]] ; then
	return
fi

. ~/.aliases

PS1='[\u@\h \W]\$ '
