# untar
# untar and unzip archives into directories of the same name
#
# Copyright (C) 2013 Mara Kim
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see http://www.gnu.org/licenses/.


### USAGE ###
# Source this file in your shell's .*rc file

function untar {
if [ "$1" -a -a "$1" ]
then
 mkdir -p "${1%.tar.gz}";
 tar -zxvf $1 -C "${1%.tar.gz}"/; 
fi }
function unzip {
if [ "$1" -a -a "$1" ]
then
 gzip -d "$1"
fi }
