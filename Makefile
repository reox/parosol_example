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
PAROSOL := parosol
# Path to h5mkgrp tool
H5MKGRP := h5mkgrp
# Path to the mpirun executable
MPIRUN := mpirun

# Path to the createxmf.py executable
CREATEXMF := createxmf

### Options for mpirun
# Get the number of cores on this computer
CORES := $(shell LANG=C lscpu | awk '/ per socket/ {print $$4}')

### Options for Parasol
# Tolerance of parosol (default is 1e-6)
TOLERANCE := 1e-7
# Level of parosol (default is 6)
LEVEL := 3

#### END OF SETTINGS

MESHNAME := $(notdir ${MESH})

XMF := $(patsubst %.h5,%.xmf,${MESHNAME})

all: ${RESULTS}/${MESHNAME} ${RESULTS}/${XMF}
	${MPIRUN} -np ${CORES} ${PAROSOL} --level ${LEVEL} --tol ${TOLERANCE} $<

${RESULTS}/${MESHNAME}: ${MESH}
	# ParOSol writes the data back into the h5 file.
	# Therefore we copy it to the result place and modify it there
	[ -d ${RESULTS} ] || mkdir -p ${RESULTS}
	cp ${MESH} ${RESULTS}/
	# We need a new group Parameters, otherwise parosol does not work...
	${H5MKGRP} ${RESULTS}/${MESHNAME} "Parameters"

%.xmf: %.h5
	# Create an xmf file from the h5 file.
	# this file can then be loaded in paraview
	${CREATEXMF} $<

clean:
	rm -rf ${RESULTS}

# Keep h5 file in results
.PRECIOUS: ${RESULTS}/${MESHNAME}

# Not real rules...
.PHONY: all clean
