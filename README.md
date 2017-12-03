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

This version is also slightly different in it's dataformat than the original
version or the tu-wien version from Elan.

It's probably best, to check the output format and adjust it to your needs.
A fork on bitbucket also contains code to switch different output formats.

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
**Beware: This userguide is wrong in some places! Use it with caution!**

Depending on the version you use, a `/Parameters` group is required (it is never
used though).
The `Makefile` adds it before passing the data to ParOSol, but you can also add
it already beforehand.

The `Image_Data/Image` dataset contains the voxels, where each value corresponds
to the elastic modulus of this voxel.
Each voxel will be a single element in the resulting mesh.
Note, that this Data is given in Z, Y, X, which means if you are writing data
using `h5py`, you need to provide a numpy array using the shape `(z, y, x)`.

Also the boundary conditions (displacements or loads) are given in this format.

But, the resulting `Mesh` will be again in X, Y, Z format! That means, if you
are reading the mesh and write back to the image, you need to swap X and Z.

A last note: ParOSol works directly on the given file. That means, if you do not
want your input data to be changed (allthough ParOSol will not write in the
Image data), you need to copy the file.

Boundary Conditions
===================

There are two types of boundary conditions known to ParOSol: Loadings and
Displacements/Fixed nodes.
BC only act on nodes, and therefore node coordinates are used in the creation of
boundary conditions.

The creation is a little bit tricky, as the format how the node coordinates is
not the same as in the `Mesh` output.
Basically the coordinate given here, is not the absolute coordinate in the unit
of voxelsize, but the number of the node along an axis.
What does this mean? Here is a short example:
If you have an image with `x * y * z` voxel, you will end up with
`(x+1) * (y+1) * (z+1)` nodes. The coordinates for your boundary condition are exactly
these numbers.
In the output mesh, the coordinates of the nodes are in the unit of voxelsize!

Beware, that you need to give the boundary condition also in the `(z, y, x)`
format - the same as the image data!

Again, the mesh data is then in `(x, y, z)` format.

Units
=====

Units are not used inside ParOSol. But If you use a consistent unit schema, all
your results will also be consistent.

**TO BE CONFIRMED**

Input Data:

* Voxelsize: [mm]
* Loading on nodes: [N] ?
* Displacements of nodes: [mm]
* E-Module (Value in `/Image_Data/Image`): [MPa]

Output Data for elements:

* Strains: all six sym. components of strain tensor
* Stresses: all six sym. components of stress tensor
* von Mises stress
* Strain energy density (`1/2 * sigma_ij * epsilon_ij`)
* Effective Strain (`sqrt(2*SED/YoungsMod`)

Output Data for nodes:

* displacements, as vector
* forces, as vector

