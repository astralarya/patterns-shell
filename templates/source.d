# source.d
# source all the files in a directory
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

# then copy the example functions below into a new file
# and edit for your needs
#
# DO NOT edit the examples in this file directly


### TEMPLATES ###

# copy the functions in this section and edit for your needs
# :s/mydir/relativepath (from sourcefile)

# source all files in mydir
for f in $(dirname $BASH_SOURCE)/mydir/*
 do source $f
done
