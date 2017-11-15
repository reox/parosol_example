# Result folder name
RESULTS := ./results

# Path to the mpirun executable
MPIRUN := /usr/lib64/openmpi/bin/mpirun
# Path to the ParOSol executable
PAROSOL := /programs/shared/medtool4.1/linux64-SL73/parosol

# Path to the createxmf.py executable
# We need hd5py for this tool :(
# Thus we can not use it on the felab machines...
CREATEXMF := ./parosol-tu-wien/tools/createxmf.py

# Get the number of cores on this computer
CORES := $(shell lscpu | awk '/ per socket/ {print $$4}')

# h5 input file to parosol
MESH := mesh/h5/sphere.h5

# Tolerance of parosol (default is 1e-6
TOLERANCE := 1e-7

# Level of parosol (default is 6)
LEVEL := 3


###
MESHNAME := $(notdir ${MESH})


all: ${RESULTS}/${MESHNAME}
	${MPIRUN} -np ${CORES} ${PAROSOL} --level ${LEVEL} --tol ${TOLERANCE} $<

${RESULTS}/${MESHNAME}: ${MESH}
	# ParOSol writes the data back into the h5 file.
	# Therefore we copy it to the result place and modify it there
	[ -d ${RESULTS} ] || mkdir -p ${RESULTS}
	cp ${MESH} ${RESULTS}/
	h5mkgrp ${RESULTS}/${MESHNAME} "Parameters"



# To view h5 files, there is hdfview
# But hdfview only shows arrays! Therefore we like to convert the image to
# a real image format and show it with paraview...
