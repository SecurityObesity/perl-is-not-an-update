#!/bin/bash
# 
# Copyright © 2018 SecurityObesity; dexoidan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function ask() {
	read -p "$1 (yes/no): "
	case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
		yes) echo -e "continue.";;
		*) echo -e "Have a good day.";;
	esac
}

# download source code
wget -qO- "http://www.cpan.org/src/5.0/perl-5.26.2.tar.gz"

# extract downloaded source code
tar -xzf perl-5.26.2.tar.gz

# deletes file
rm -rf perl-5.26.2.tar.gz

echo -e "Asking user permissions"
echo -e "Install files and folders"

sudo touch file

# change directory to perl-5.26.2
cd perl-5.26.2

# Initiate compilation dependency configuration
# Choosing prefix to /usr then it is possible to downgrade perl

# Make sure Configure is running before compilation process is started
./Configure -des -Dprefix=$HOME/localperl

echo -e "Checking dependency configuration finished"
echo -e "Compiling started..."

# Compile
make &> /dev/null

echo -e "Compilation is now done..."
echo -e "Checking all compiled executables in test..."

# Check compiled library and binary executables
make test &> /dev/null

echo -e "Checking all compiled executables in test is now done..."
echo -e "Installing..."

# do install the packages
sudo make install

cd ..

echo -e "Installation is complete."

sudo rm -rf perl-5.26.2 file

# Update alternatives to the new install directory
declare -a listarr=("corelist" "encguess" "instmodsh" "perl" "perldoc"
"piconv" "pod2man" "podchecker" "ptar" "shasum" "zipdetails" "cpan" "h2ph"
"json_pp" "perlivp" "pl2pm" "pod2text" "podselect" "ptardiff" "splain"
"enc2xs" "h2xs" "libnetcfg" "perlbug" "perlthanks" "pod2html" "pod2usage"
"prove" "ptargrep" "xsubpp")

for i in ${listarr[@]}
do
	getexecpathfind=`which $i`
	commands='sudo update-alternatives --install "'$getexecpathfind'" "'$i'" "~/localperl/bin" 1'
	eval($commands)
done

if [[ $(ask "Do you want to upgrade the perl modules for the current system") == "yes" ]];
then
	sudo perl -MCPAN -e "upgrade /(.\*)/"
fi