# This is a minimal working example, how to use ParOSol
#
# We take the mesh files provided in the mercurial repo:
# https://bitbucket.org/Elankumaran/parosol-tu-wien
#
# Set your desired settings (e.g. path to parosol and mpirun) in the settings
# section, then run `make`
#
# Author: Sebastian Bachmann <sebastian.bachmann@tuwien.ac.at>, 2017

#### BEGIN OF SETTINGS
# Result folder name
RESULTS := ./results

# h5 input file to parosol
MESH := mesh/h5/sphere.h5

### Tool Paths
# Path to the ParOSol executable
PAROSOL := /programs/shared/medtool4.1/linux64-SL73/parosol
# Path to h5mkgrp tool
H5MKGRP := /usr/lib64/openmpi/bin/h5mkgrp
# Path to the mpirun executable
MPIRUN := /usr/lib64/openmpi/bin/mpirun

# Path to the createxmf.py executable
# We need hd5py for this tool :(
# Thus we can not use it on the felab machines...
CREATEXMF := ./parosol-tu-wien/tools/createxmf.py

### Options for mpirun
# Get the number of cores on this computer
CORES := $(shell lscpu | awk '/ per socket/ {print $$4}')

### Options for Parasol
# Tolerance of parosol (default is 1e-6
TOLERANCE := 1e-7
# Level of parosol (default is 6)
LEVEL := 3

#### END OF SETTINGS

MESHNAME := $(notdir ${MESH})

all: ${RESULTS}/${MESHNAME}
	${MPIRUN} -np ${CORES} ${PAROSOL} --level ${LEVEL} --tol ${TOLERANCE} $<

${RESULTS}/${MESHNAME}: ${MESH}
	# ParOSol writes the data back into the h5 file.
	# Therefore we copy it to the result place and modify it there
	[ -d ${RESULTS} ] || mkdir -p ${RESULTS}
	cp ${MESH} ${RESULTS}/
	# We need a new group Parameters, otherwise parosol does not work...
	${H5MKGRP} ${RESULTS}/${MESHNAME} "Parameters"

clean:
	rm -rf ${RESULTS}

.PHONY: all clean


# To view h5 files, there is hdfview
# But hdfview only shows arrays! Therefore we like to convert the image to
# a real image format and show it with paraview...
