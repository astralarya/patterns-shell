# patterns-shell

**patterns-shell** - Tempate patterns for shell scripts


## Installation

You can manually copy this repository, but it is better to clone it via `git` with

>git clone https://github.com/resultsreturned/patterns-shell.git

Then you can easily get updates with

>git pull


## Patterns

### Scripts
* *history* - persistent shell history with advanced search
* *prompt* - pretty programmable prompt
* *untar* - untar and unzip archives

For detailed descriptions of these scripts,  
see `scripts/README.md`

### Templates

You can use templates to generate code.
* **deploy**
    * **template-deploy-client** - Client side deploy methods
    * **template-deploy-server** - Server side deploy methods
* **pgdb**
    * *template-db* - Generate function to access a database as a user
    * *template-dbbackup* - Generate function to backup and restore a database
* **remote**
    * Generate functions to connect to a server via SSH, setup public/private key authorization,
      start a SOCKS proxy, and push/pull files via SCP.
* **sourcedir**
    * *template-sourcedir* - Generate script to source all files in a directory

For detailed descriptions of these functions and the code they generate,  
see `templates/README.md`

## License

patterns-shell

Copyright (C) 2013  Mara Kim, Kris McGary

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
