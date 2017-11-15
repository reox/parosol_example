
# Path to the mpirun executable
MPIRUN := /usr/lib64/openmpi/bin/mpirun
# Path to the ParOSol executable
PAROSOL := /programs/shared/medtool4.1/linux64-SL73/parosol
# Get the number of cores on this computer
CORES := $(shell lscpu | awk '/ per socket/ {print $$4}')

all:
	${MPIRUN} -np ${CORES} ${PAROSOL} --level 3 --tol 1e-7 mesh/h5/sphere.h5
