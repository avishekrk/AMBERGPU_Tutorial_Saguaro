#!/bin/bash
# Downloads pdb from pdb databank from commandline class exercise
# Written 2013 Avishek Kumar <avishek.kumar@asu.edu>
# Released into the public domain (can be used by anyone without
# limitations; you may delete all comments at the top)
#BUGFIX needed to use .pdb$ regular expression when finding the extension
#BUGFIX would download an empty file. Now checks andd deletes those files 

PROGRAM=$(basename $0)

usage="usage: ${PROGRAM} [options] ARG1 [ARG2 ...]

Downloads pbds from the protein databank.

Options:

-h             show this help
-d DIRECTORY   someting is being done with this directory
ARG            pdb files
"""

PDBURL="http://www.rcsb.org/pdb/files/"
CASP10URL="http://predictioncenter.org/casp10/target.cgi?view=template&target="
CASP9URL="http://predictioncenter.org/casp9/target.cgi?view=template&target="


function die () {
# die errormessage [error_number]
local errmsg="$1" errcode="${2:-1}"
echo "ERROR: ${errmsg}"
exit ${errcode}
}

function warn () {
# warn message
local msg="$1"
echo "WARNING: ${msg}"
return
}

function check_directory() {
#check if the directory exits if no create it

if [ ! -d $1 ]
then
echo "${1} does not exist..creating it now"
mkdir -vp ${1}
fi

}

#------------------------------------------------------------
# main script
#------------------------------------------------------------

#------------------------------------------------------------
# process options and arguments
#
# default directory is current dir
DIRECTORY="."
while getopts hd: OPT; do
case "${OPT}" in
h)  echo "${usage}";
exit 0
;;
d)  DIRECTORY="${OPTARG}"
;;
?)  die "unknown option or missing arument; see -h for usage" 2
;;
esac
done

shift $((OPTIND - 1))
FILES="$*"
#
#------------------------------------------------------------

#input check
if [ -z "${FILES}" ];
then
die "No PDBs specified. -h for help"
fi

echo "processing PDBIDS: ${FILES}"

for pdb in ${FILES}; do

#check to see if the pdb extension is added and strip it if so
if $(echo $pdb | grep -q ".pdb$")
then
echo "Entered the whole filename. Stripping the .pdb"
pdb=$(echo $pdb | cut -d. -f1)
fi   

pdb=$(echo ${pdb} | tr '[A-Z]' '[a-z]')
DESTINATION="${DIRECTORY}/${pdb}.pdb"

check_directory ${DIRECTORY}

if $(echo $pdb | grep -q "^tr")
then
    echo "CASP10 Target"
    pdb=$(echo ${pdb} | tr '[a-z]' '[A-Z]')
    curl "${CASP10URL}${pdb}" > "${DIRECTORY}/${pdb}.pdb"
    if [ 1 -eq "$(wc -l "${DIRECTORY}/${pdb}.pdb" | cut -d' ' -f1)" ]; then echo "CASP 9 TARGET"; curl "${CASP9URL}${pdb}" > "${DIRECTORY}/${pdb}.pdb"; fi 

else
    curl "${PDBURL}/${pdb}.pdb" > "${DIRECTORY}/${pdb}.pdb"
fi

#check if sucessful 
if [[ ! -s "${DIRECTORY}/${pdb}.pdb" || 1 -eq "$(wc -l "${DIRECTORY}/${pdb}.pdb" | cut -d' ' -f1)" ]]
then
echo "${pdb} file download unsuccessful"
rm -v "${DIRECTORY}/${pdb}.pdb"
else
echo "${pdb} download successful"
fi
done
