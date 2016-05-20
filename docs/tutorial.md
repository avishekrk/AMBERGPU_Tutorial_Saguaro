# GPU Tutorial 
by Avishek Kumar avishek@asu.edu
## Description 
This is a tutorial on how to run a AMBER14 GPU-acceleration MD Simulation on Saguaro/NGCC and how to automate an MD workflow. 

## Log-in to Saguaro
```
ssh asuriteid@saguaro.fulton.asu.edu
```
## Git Tutorial Materials 
```
git clone --depth 1 <repo>
```
If you get an error that says you cannot open a display use the following comand. 
```
unset SSH_ASKPASS
```


## GPUBIN
GPU Bin contains all scripts and codes needed to run the simulations
```
gpubin/
├── bckup_minimize_solvent.sh
├── heat.in
├── heatup.sh
├── makestructure.py
├── minimization_solution.in
├── minimization_solvent.in
├── minimize_solution.sh
├── minimize_solvent.sh
├── production.in
├── production.sh
├── test_production.in
└── test_production.sh
```

# Running in a Simulation In Amber

## Outline: 
1. Create a topology and coordinate file 
2. Minimize the Structure 
    1. Minimize the Solvent
    2. Minimize the Solution
    3. Heat the System 
3. Run Production 
    - Run CPU test production for electrostatics 

- Appendix SLURM


# 1. Create a topolgy and coordinate file 
First you must must make a topology and coordinate file from a pdbfile. **This is also the first place you can trip up.**
```
>mkdir structure
>cd structure
>./../gpubin/download_pdb.sh 2K6O
```
2K60 is a 37-residue protein that was characterized by NMR. First we have to extract the firlst model and remove an HETATOMs. 
### Pull First Model out of PDBFILE
```
>grep -n "ENDMDL" 2k6o.pdb
797:ENDMDL
1464:ENDMDL
2131:ENDMDL
2798:ENDMDL
>head -797 2k6o.pdb | grep "^ATOM" > 2k6OMD.pdb
```
### Create the paramater and coordinate file
```
module load python/2.7.9
/../gpubin/makestructure.py 2K6OMD.pdb 10
```

The second arguement if for the dimensions of the waterbox in Angstroms. 
# 2. Minimize the Sructure 

1. Minimize solvent 
2. Minimize solute 
3. Heat-Up the system.

```
>mkdir minimize
>cd minimize 
>cp -v ./../structure/2K60_TIP3P.* . 
srun -p cuda ./../gpubin/minimize.sh 2K6O_TIP3P.prmtop 2K6O_TIP3P.incrd 
```

# 3 Run Production
```
> cd ./../
> mkdir production 
> cd production 
> cp -v ./../minimize/2K6O_TIP3P.prmtop
> cp -v ./../minimize/2K6O_TIP3P-heatup.rst
> srun -p cuda ./../gpurun/production.sh 2K6O_TIP3P.prmtop 2K6O_TIP3P-heatup.rst   
```
If you get the error that the grid is unstable run for 100ps on a CPU-node. 
```
srun -p serial ./../gpurun/test_cpu_prouduction.sh 2K6O_TIP3P.prmtop 2K6O_TIP3P-heatup.rst
```



# Appendix: SLURM
Submit a job via commandline 
```
srun -p <partition> -t d-hh:mm -mem 500 --pty /usr/bin
```
Run an interactive job
```
srun -p cuda --pty --mem 500 -t 0-06:00 /bin/bash
```
Get information about the cluster and partitions
```
sinfo 
```
Check status of job by user
```
squeue -u <name>
```
Check status of jobs by queue 
```
squeue -p <partition-name>
```