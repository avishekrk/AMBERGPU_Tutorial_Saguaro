#!/bin/bash
#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l walltime=220:00:00
#PBS -l mem=1GB
#PBS -j oe
#PBS -q shortq

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


PARM=$1
CRD=$2
title=$(echo $PARM | cut -d. -f1)


if [ -z "${PARM}"]; 
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


module load gcc/4.9.2 cuda/7.0 ambertools/14 python/2.7.9
AMBERHOME=/packages/6x/ambertools/14/

echo $PARM
echo $CRD
echo $title 

#cp -v ~/BetalactamaseGPURuns/scripts/test_cpu_production.in . 

${AMBERHOME}/bin/pmemd -O \
-i ./../gpubin/test_cpu_production.in \
-o test_cpu_production.out \
-p ${PARM} \
-c ${CRD} \
-r ${title}-testcpuprod.rst \
-x ${title}-testcpuprod.mdcrd \
-ref ${CRD} 

#${AMBERHOME}/bin/amberpdb -p ${PARM} < ${CRD} > ${title}-min2.pdb 
