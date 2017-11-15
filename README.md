Prequisites on Debian
====================
Install the following packages

    libopenmpi-dev hdf5-tools openmpi-bin

For inspecting the data, these packages are required:

    paraview hdfview

Building ParOSol
================

Use this repository: [reox/parosol-tu-wien](https://github.com/reox/parosol-tu-wien)
and follow the build instructions there.

Using ParOSol
=============

The `Makefile` contains the bare minimum to run an analysis on the samples from
the ParOSol repository.

First, adjust the paths in `Makefile`. We assume that you checked out the
parosol-tu-wien repository one folder below this repository and already
successfully build ParOSol.
Otherwise you have to adjust the paths of `parosol` and `createxmf.py` binaries
too.

By default, we configure `mpirun` to use all available physical CPU cores. Be
aware of that!

The example will use the mesh `sphere.h5`.

If you run `make`, ParOSol will make the calculations and write the results back
into `results/sphere.h5`. Also a `results/sphere.xmf` file will be created.
Open this file using `paraview`.

If everything was successful, you should see something like this:

![Image of sphere.h5](/images/deathstar.png)
