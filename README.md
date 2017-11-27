Prequisites on Debian
====================
For inspecting the data, these packages are suggested:

    paraview
    hdf-compass | hdfview

To use the `Makefile` you need `hdf5-tools` as well as the ParOSol package
installed.

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

Create own input data
=====================

Using the tool `h5dump`, you can inspect existing data.
A description of the dataformat is available in the [userguide](https://github.com/reox/parosol-tu-wien/blob/master/doc/userguide.mkd#file-format).

Depending on the version you use, a `/Parameters` group is required (it is never
used though).
The `Makefile` adds it before passing the data to ParOSol, but you can also add
it already beforehand.

Units
=====

Units are not used inside ParOSol. But If you use a consistent unit schema, all
your results will also be consistent.

**TO BE CONFIRMED**

Input Data:

* Voxelsize: [mm]
* Loading: [MPa]
* E-Module (Value in `Image_Data`): [MPa]

Output Data:

* Strains: all six components of strain tensor + SED + Effective Strain (`sqrt(2*SED/YoungsMod`)
* Stresses: all six components of stress tensor + Von Mises

