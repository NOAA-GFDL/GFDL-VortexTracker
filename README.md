# GFDL Vortex Tracker

The GFDL Vortex Tracker is a software tool developed at NOAA's Geophysical Fluid Dynamics Laboratory (GFDL) that identifies and analyzes tropical cyclones in numerical weather model output — diagnosing a storm's location, intensity, and wind structure over time. It has supported National Weather Service and U.S. Navy operations for more than two decades, plays a role in NOAA's Hurricane Analysis and Forecast System (HAFS), and is the standard hurricane tracking tool within NOAA's Unified Forecast System (UFS).

📖 **For full installation, configuration, and troubleshooting details, see the [complete User's Guide](docs/UserGuide.md).**

## Quick Start

### If you have NOAA RDHPCS access

```bash
# 1. Clone the repository
git clone https://github.com/NOAA-GFDL/GFDL-VortexTracker.git
cd GFDL-VortexTracker

# 2. Compile (replace <system> with gaea, hera, hercules, orion, ppan, ursa, or wcoss2)
cd compile
./compiletrkr.sh <system>

# 3. Verify the build
cd src_code
ls exec/    # should contain the compiled executables
```

Then, to run the tracker:

```bash
# 4. Fill out required config files
cd ../../run/init_data
# edit leadtimes.txt (required) and other files as needed — see the User's Guide for formatting rules

# 5. Choose your data format and edit the setup script
cd ../scripts/netcdf      # or ../scripts/grib
# edit setup_netcdf.sh (or setup_grib.sh) with your run's settings
# NetCDF users: also edit atmos_netcdfvars.sh

# 6. Execute
./setup_netcdf.sh | tee run.log
```

### If you don't have NOAA RDHPCS access

There's no fully streamlined workflow yet for non-RDHPC systems. Options currently available:

- **Spack:** install dependencies locally using the spec list in the [User's Guide](docs/README.md#422-spack) as a starting point (comprehensive instructions coming soon)
- **Container:** pull the project's CI container image and build manually with `cmake` — see the [User's Guide](docs/README.md#424-containerized-environment) for steps

A more streamlined, user-friendly build/run workflow for non-RDHPC systems is planned for a future release.

## Documentation

| Resource | Description |
|---|---|
| [User's Guide](docs/README.md) | Full installation, configuration, running, output, and troubleshooting reference |
| [Genesis Detection](docs/genesisdoc.md) | Details on the tracker's genesis detection (`tcgen`) mode |
| [Wind Radii](docs/radiidoc.md) | Details on wind radii and axisymmetric RMW diagnostics |

## Status

This repository is the community version of the GFDL Vortex Tracker. NOAA RDHPCS remains the primary supported platform; support for additional environments (Spack, containers) is under active development. More comprehensive technical documentation on the tracker's internals is also in progress and expected to be published soon.
