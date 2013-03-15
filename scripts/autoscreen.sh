# autoscreen
# auto start screen session without inception
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

# source this after all other setup files
if [ -z "$STY" ]
then
 echo "Starting screen. ^C to cancel..."
 sleep 2
 # start screen session
 screen -D -RR
 # close shell or connection after termination
 clear
 echo "Screen terminated. Exiting. ^C to cancel..."
 sleep 2
 exit
fi

