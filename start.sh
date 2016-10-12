#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors base:
#   Sam Hewitt <hewittsamuel@gmail.com>
#
# Authors:
#   Igor Dyatlov <dyatlov.igor@gmail.com>
#
# Description:
#   A post-installation bash script for Ubuntu
#
# Legal Preamble:
#
# This script is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; version 3.
#
# This script is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/gpl-3.0.txt>

# tab width
tabs 4
clear

#----- Import Functions -----#

dir="$(dirname "$0")"

. $dir/functions/check
. $dir/functions/cleanup
. $dir/functions/configure
. $dir/functions/kernel
. $dir/functions/speedup
. $dir/functions/thirdparty
. $dir/functions/thirdparty-theme
. $dir/functions/update

#----- Fancy Messages -----#
show_error(){
echo -e "\033[1;31m$@\033[m" 1>&2
}
show_info(){
echo -e "\033[1;32m$@\033[0m"
}
show_warning(){
echo -e "\033[1;33m$@\033[0m"
}
show_question(){
echo -e "\033[1;34m$@\033[0m"
}
show_success(){
echo -e "\033[1;35m$@\033[0m"
}
show_header(){
echo -e "\033[1;36m$@\033[0m"
}
show_listitem(){
echo -e "\033[0;37m$@\033[0m"
}

function main {
  eval `resize`
  MAIN=$(whiptail \
    --notags \
    --title 'Ubuntu Post-Install Script' \
    --menu '\nWhat would you like to do?' \
    --ok-button 'Run' \
    --cancel-button 'Quit' \
  $LINES $COLUMNS $(( $LINES - 12 )) \
    update 'Perform system update' \
    thirdparty 'Install third-party applications' \
    thirdparty-theme 'Install third-party theme' \
    configure 'Configure system' \
    kernel 'Update system kernel' \
    cleanup 'Cleanup the system' \
    speedup 'Speed up system' \
  3>&1 1>&2 2>&3)

exitstatus=$?
  if [ $exitstatus = 0 ]; then
    clear && $MAIN
  else
    clear && quit
  fi
}

function quit {
  if (whiptail --title "Quit" --yesno "Are you sure you want quit?" 10 60) then
    exit 99
  else
    clear && main
  fi
}

check && main
