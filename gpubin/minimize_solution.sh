#!/bin/bash

usage="""
Minimize Solution
=================

Description
-----------
Shell script for minimizing solution in AMBER GPU explict water simulation

Usage
-----
./minimize_solution PARMFIL CRDFIL 
"""

module load gcc/4.9.2 cuda/7.0 ambertools/14 python/2.7.9
AMBERHOME=/packages/6x/ambertools/14/
PATH=${PATH}:/home/akumar67/scripts

PARM=1l2yMD_TIP3P.prmtop
CRD=1l2yMD_TIP3P-min1.rst
title=$(echo $PARM | cut -d. -f1)


if [ -z "${PARM}" ]; 
then
    echo "NO PRMTOP FILE"
    echo "$usage" 
    exit 
fi

if [ -z "${CRD}" ];
then
    echo "NO CRD FILE"
    echo "$usgae"
    exit 
fi 

echo $PARM
echo $CRD
echo $title 

#cp -v ~/BetalactamaseGPURuns/scripts/minimization_solution.in . 

${AMBERHOME}/bin/pmemd.cuda -O \
-i minimization_solution.in \
-o minimization_solution.out \
-p ${PARM} \
-c ${CRD} \
-r ${title}-min2.rst \

${AMBERHOME}/bin/amberpdb -p ${PARM} < ${CRD} > ${title}-min2.pdb 
