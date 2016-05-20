#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l walltime=240:00:00
#PBS -l mem=1GB
#PBS -j oe
#PBS -q gpu

#cd $PBS_O_WORKDIR

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

PARM=$1
CRD=$2
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
    echo "$usage"
    exit 
fi 
echo $AMBERHOME

echo $PARM
echo $CRD
echo $title 



${AMBERHOME}/bin/pmemd.cuda -O \
-i ./../gpubin/production.in \
-o production.out \
-p ${PARM} \
-c ${CRD} \
-r ${title}-prod.rst \
-x ${title}-prod.mdcrd \
-ref ${CRD} 

#${AMBERHOME}/bin/amberpdb -p ${PARM} < ${CRD} > ${title}-min2.pdb 
