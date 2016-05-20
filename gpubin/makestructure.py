#!/usr/bin/env python 
"""
MakeStructure
==============

Description
------------
Make a tleapin file for a simulation that is neutralized and solaved with 
8 Angstroms Boundaries. 

Example
--------
makestructure.py 1btl.pdb 

"""


import sys 
import os 

def maketleapscript(pdbfile,waterbound="14.0"):
    """makes tleapin script for preparing structure"""

    outfil='tleapin.txt'
    outfile=open(outfil,'w')
    title=pdbfile.strip('.pdb')
    data = {'pdbfile': pdbfile, 'title': title, 'waterbound': waterbound }
    script="""source /packages/6x/ambertools/14/dat/leap/cmd/leaprc.ff14SB
loadamberparams frcmod.ionsjc_tip3p
{title} = loadpdb "{pdbfile}"
addions {title} Na+ 0 
addions {title} Cl- 0 
solvatebox {title} TIP3PBOX {waterbound} 
charge {title}
saveamberparm {title} {title}_TIP3P.prmtop {title}_TIP3P.inpcrd
quit
""".format(**data)
    outfile.write(script)
    print "Wrote script out to {}".format(outfil)
    outfile.close()

if __name__ == "__main__":
    
    if len(sys.argv) < 2:
        print "No Input File"
        sys.exit(1)

    pdbfile = sys.argv[1]
    if len(sys.argv) < 3:
        print "No water box boundary Defaulting to 14 Angstroms"
        maketleapscript(pdbfile)
    else:
        maketleapscript(pdbfile,waterbound=sys.argv[2])     
    ngcc_modules="""module load gcc/4.9.2 ambertools/14 python/2.7.9;
export AMBERHOME=/packages/6x/ambertools/14/;
tleap -f tleapin.txt"""
    
    os.system(ngcc_modules)
