# 🌊 GFDL Vortex Tracker 🌀

This program tracks the average of the max or min of several parameters in the vicinity of an input
first guess (lat,lon) position of a vortex in order to give forecast position estimates for that vortex for
given numerical model.  For the levels 700 & 850 mb, the tracked parameters are:
Relative vorticity (max), wind circulation (max), and geopotential height (min). 
At the surface, the 10-m relative vorticity, wind circulation and MSLP are tracked. 
So many parameters are tracked in order to provide more accurate 
position estimates for weaker storms, which often have poorly defined structures/centers.
Currently, the system is set up to be able to process input files in either GRIB1, GRIB2 or NetCDF format. The tracker use input data from global models and regional models, including those with moveable grids. Text output files from the tracker contain diagnostics for a range of forecast variables. The main output file is in ATCF format, which is the format needed by the National Hurricane Center, and provides forecast guidance at lead times that the user requests.

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

The tracker is currently set up to compile and install on RDHPC systems: Gaea, Jet, Hera, PPAN, Orion, Hercules and WCOSS2.
There are two ways to use the cmake build:

### Option 1 (automatic) ###
```
git clone git clone https://github.com/NOAA-GFDL/GFDL-VortexTracker.git
cd code/
cd src/
./run-cmake.sh
```

### Option 2 (manual) ###
```
git clone git clone https://github.com/NOAA-GFDL/GFDL-VortexTracker.git
cd code/
mkdir build && cd build
source ../modulefile-setup/<name of computer>-setup.sh    # for example, ppan-setup.sh or jet-setup.sh
cmake ..
make
make install
```
<br />

❗ Things to know in order to successfully compile: <br />
    Some RDHPC systems require a clean module environment before compiling, <br />
    if that is the case ensure that a module purge is done first before running any cmake commands

### Running the Vortex Tracker

Before running a few steps need to be taken:
* Edit leadtimes
* Edit tcvit_date file
* Edit runscript

**Note:** This runscript is configured for bash shells, if the user is using a different shell please change necessary variables <br />
Also, note that the runscript only works for netcdf data for the time being. <br /> <br />


**Leadtimes** <br />
Edit the `tracker_leadtimes` script with the leadtimes that match the input data <br />
These times must be in minutes <br />
The file is already populated with times as an example of what the file should look like <br />
❗ **Important** ❗Due to the way the runscript reads the times in this file, <br />
the formatting of the times is very important. <br />
Please ensure the values in each column and row stay in the spaces they are currently in. <br /> <br />

**Runscript** <br />
` cd run/ ` <br />
Edit `runtracker.sh` with the editor of your chosing <br />
Search for the word "USER", this will bring you to all of the sections that need to be modified <br />
Follow along with the comments in the script for instructions

**Edit tcvit_date file** <br />
`cd files/bin` <br />
Edit `tcvit_date` file
Once again, search for the word "USER" to find where paths will need to be added


If any problems or questions arise please email Caitlyn --> caitlyn.mcallister@noaa.gov <br />
or Tim Marchok --> timothy.marchok@noaa.gov


### Testing the Tracker
A full testing suite is being created - tests will be added as they are completed
