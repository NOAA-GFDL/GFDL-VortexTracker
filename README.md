# 🌊 GFDL Vortex Tracker 🌀

  This program tracks the average of the max or min of several parameters in the vicinity of an input
first guess (lat,lon) position of a vortex in order to give forecast position estimates for that vortex for
given numerical model.  For the levels 700 & 850 mb, the tracked parameters are:
Relative vorticity (max), wind magnitude (min), and geopotential height (min). 
Also tracked is the min in the MSLP. So many parameters are tracked in order to provide more accurate 
position estimates for weaker storms, which often have poorly defined structures/centers.
Currently, the system is set up to be able to process GRIB input data files from the GFS, MRF, UKMET, GDAS,
ECMWF, NGM, NAM and FNMOC/NAVGEM models. Two 1-line files are  output from this program, both containing the 
forecast fix positions that the  tracker has obtained.  One of these  output files contains the positions at 
every 12 hours from forecast hour 0 to the end of the forecast. The other file is in ATCF format, which is 
the particular format needed by the Tropical Prediction Center, and provides the positions at forecast hours
12, 24, 36, 48 and 72, plus the maximum wind near the storm center at each of those forecast hours.

For more documentation on how the tracker runs in genesis mode or the wind radii and axisymmetric diagnostic schemes please see genesisdoc.md and radiidoc.md, respectively.

## Dependices, Installation, Compiling, Running, Testing

The following external libraries are required for buildig the vortex tracker:
  * NETCDF and Fortran (77/90)
  * Fortran standard compiler
  * PNG
  * Jasper
  * Zlib
  * NCEP libraries: g2, bacio, w3nco, w3emc

### Instructions for building & installing with cmake:

The tracker is currently set up to compile and install on RDHPC systems: Gaea, Jet, Hera, PPAN, and WCOSS2.
There are two ways to use the cmake build:

### Option 1 (automatic) ###
```
git clone git clone https://github.com/NOAA-GFDL/GFDL-VortexTracker.git
cd src/
./run-cmake.sh
```

### Option 2 (manual) ###
```
git clone git clone https://github.com/NOAA-GFDL/GFDL-VortexTracker.git
mkdir build && cd build
source ../modulefiles/modulefile<name of machine>    # for example, modulefile.ppan or modulefile.jet
cmake ..
make
make install
```

❗ Things to know in order to successfully compile: <br />
    If on PPAN -- ensure that you have a clean module environment before running the modulefile.ppan <br />
    If on GAEA -- user will need to set this environment variable <br />
               `export LD_PRELOAD=/opt/cray/pe/gcc/12.2.0/snos/lib64/libstdc++.so.6`    # if on bash <br />
               `setenv LD_PRELOAD /opt/cray/pe/gcc/12.2.0/snos/lib64/libstdc++.so.6`    # if on csh  <br />

### Running the Vortex Tracker

As of now, the user will need to create their own run script to use the tracker with.
COMING SOON -- 
More instructions on what input the tracker needs to funtion properly
A runscript that will be provided is currently in progress

### Testing the Tracker
A full testing suite is being created - tests will be added as they are completed
