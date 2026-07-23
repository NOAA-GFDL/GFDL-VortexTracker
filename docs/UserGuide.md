# 1. Introduction

Welcome to the GFDL Vortex Tracker User's Guide. This guide provides step-by-step instructions for installing, configuring, and running the GFDL Vortex Tracker from its GitHub repository.

## What is the GFDL Vortex Tracker?

The GFDL Vortex Tracker is a software tool developed by scientists at NOAA's Geophysical Fluid Dynamics Laboratory (GFDL) that identifies and analyzes tropical cyclones in numerical weather model output. Given a model's forecast data, the tracker diagnoses a storm's location, intensity, and wind structure over time, turning large volumes of raw model output into clear, actionable guidance.

The tracker has supported National Weather Service and U.S. Navy weather operations for more than two decades, and plays a role in NOAA's Hurricane Analysis and Forecast System (HAFS) — both in helping initialize a storm's position and structure at the start of a model forecast, and in diagnosing the storm as the forecast progresses. It has also been selected as the standard hurricane tracking tool within NOAA's Unified Forecast System (UFS).

In 2025, a community version of the tracker was released on GitHub, adding a vortex tilt diagnostic (showing whether a storm's center shifts or leans with height) and improving the tracker's portability, accessibility, and documentation for use outside of NOAA's operational environment. This guide covers that community version.

## Who Maintains the Tracker

The Vortex Tracker is developed and maintained by meteorologists in the Weather and Climate Dynamics Division at GFDL, including Tim Marchok (the tracker's original developer, with NOAA since 1994) and Caitlyn McAllister, who has led recent work on the tracker's build systems, CI/CD workflows, containerized environments, and documentation to make the tracker more accessible to the broader community.

## Who This Guide Is For

This guide is intended for researchers, developers, operational users, and students who want to build and run the tracker. It covers:

- Installing required software and dependencies
- Building the tracker using the supported build system
- Configuring input files and runtime settings
- Executing the tracker on your data
- Interpreting the generated output
- Troubleshooting common installation and runtime issues

## A Note on Scope

You don't need to understand the tracker's internal source code or algorithms to use it day-to-day — the tracker is designed so that, in normal use, you only need to edit a small set of user-facing configuration files. This guide focuses on that user-facing workflow. Readers interested in the tracker's internal diagnostic algorithms (e.g. genesis detection, wind radii) can find additional technical detail in `docs/genesisdoc.md` and `docs/radiidoc.md`.

More comprehensive technical documentation — covering exactly how the tracker works at its core and precisely what it does under the hood — is currently being developed and is expected to be made public soon.


# 2. Repository Structure

A high-level map of the GFDL Vortex Tracker repository, to help orient you before diving into the setup/run steps.

- **`compile/`**
  - `compiletrkr.sh` — Main compile script (RDHPC users)
  - **`src_code/`** — Source code
    - `cmake/` — CMake build configuration
    - `trkr_src/` — Core tracker source code
    - `sup_src/` — Supporting source code
    - `images/` — Reference figures used in `radiidoc.md`
    - `exec/` — Compiled executables (created after a successful build)
  - **`system-envs/`** — Per-system module/environment setup, used by `compiletrkr.sh`
    - `intel/` — One file per RDHPC system (gaea, hera, hercules, orion, ppan, ursa, wcoss2)
    - `gcc/` — Same, for the gcc compiler option
- **`run/`**
  - `init_data/` — User-filled-out config files (leadtimes, levels, vortex tilt vars) — see Chapter 5
  - **`scripts/`**
    - `netcdf/` — `setup_netcdf.sh` + `atmos_netcdfvars.sh` (NetCDF data path)
    - `grib/` — `setup_grib.sh` (GRIB data path)
  - **`subscripts/`** — Internal scripts the tracker uses automatically — not meant to be edited directly
    - `archived_vitals/` — Historical tcvitals reference data, by year
- **`docs/`**
  - `genesisdoc.md` — Documentation on genesis/tcgen mode
  - `radiidoc.md` — Documentation on wind radii output
- **`.github/`**
  - `workflows/` — CI/CD configuration (see Chapter 4.2.4, Containerized Environment)

## Key Directories at a Glance

| Directory | What it's for | Do you need to touch it? |
|---|---|---|
| `compile/` | Building the tracker executables | Yes — run `compiletrkr.sh` (RDHPC) or build manually (non-RDHPC) |
| `run/init_data/` | Config data files (leadtimes, levels, vortex tilt) | Yes — fill these out before running |
| `run/scripts/netcdf/` or `grib/` | Your setup script and (for NetCDF) variable mapping | Yes — this is your main point of configuration |
| `run/subscripts/` | Internal logic the tracker runs automatically | No — not meant to be edited directly |
| `docs/` | Supplementary documentation (genesis mode, wind radii) | Optional reference |


# 3. Getting Started

## 3.1 Prerequisites

### 3.1.1 Development Tools

Before building the tracker, you'll need:

- Git
- CMake
- A C compiler
- A C++ compiler
- A Fortran compiler

On NOAA RDHPCS, these are provided automatically via system modules loaded by `compiletrkr.sh`. On other systems, you'll need to ensure these are available yourself.

⚠️ All of the tracker's scripts (compile and run) are written for and expect a **bash** shell.

### 3.1.2 Dependencies

The tracker depends on several external libraries, including HDF5, NetCDF (C and Fortran), zlib, libpng, Jasper, bacio, and various GRIB-handling libraries (g2c, g2, g2tmpl, w3emc, grib-util, wgrib2), along with NCO and CDO. See Chapter 4 (Installation and Building) for details on how these are managed in each supported environment.

### 3.1.3 Recommended Knowledge

Users should be familiar with:

- Basic Linux command-line operations
- Git
- Compiling scientific software
- Shell scripting (bash)

You do not need familiarity with the tracker's internal Fortran source code or diagnostic algorithms to install, configure, and run the tracker — see Chapter 1 (Introduction) for more on this.

## 3.2 Supported Computing Environments

The GFDL Vortex Tracker currently supports the following environments:

| Environment | Status |
|---|---|
| NOAA RDHPCS (Gaea, Hera, Hercules, Orion, PPAN, Ursa, WCOSS2) | Fully supported — automated build via `compiletrkr.sh` |
| Local system with Spack | Supported — comprehensive step-by-step instructions coming soon |
| Containerized environment (CI image) | Available, but intended for development/testing, not yet a streamlined end-user workflow |
| Manual dependency installation (no package manager) | Technically possible, but not recommended or tested by the maintainers |

Additional installation methods, including a more streamlined containerized workflow, are planned for future releases.

## 3.3 Required Input Data

Running the tracker requires meteorological model output in either NetCDF or GRIB (GRIB1 or GRIB2) format, along with a set of runtime configuration files. Specific input file requirements and configuration details are covered in Chapter 5.


# 4. Installation and Building

## 4.1 Clone the Repository

Regardless of which environment you're using, start by cloning the repository:

```
git clone https://github.com/NOAA-GFDL/GFDL-VortexTracker.git
cd GFDL-VortexTracker
```

**Expected outcome:** A local copy of the repository has been created.

## 4.2 Configuration Methods

### 4.2.1 NOAA RDHPCS

If you have access to NOAA's RDHPC systems, compiling the tracker is a mostly automated process using the provided `compiletrkr.sh` script.

**Steps:**

1. Move into the `compile` directory:
   ```
   cd compile
   ```
2. Run the compile script, specifying your system:
   ```
   ./compiletrkr.sh <system>
   ```

**Required argument:**

| Argument | Valid options |
|---|---|
| `system` | `gaea`, `hera`, `hercules`, `orion`, `ppan`, `ursa`, `wcoss2` |

This tells the script which system-specific environment/module setup to load, and is required — the script exits with an error if it's omitted.

**Optional flags:**

You can customize the build further, in the order: `./compiletrkr.sh <system> [compiler] [mode] [clean]`

| Flag | Valid options | Default | Description |
|---|---|---|---|
| `compiler` | `intel`, `gcc` | `intel` | Which compiler to build with. `gcc` is not available on `gaea` or `wcoss2`. |
| `mode` | `prod`, `debug` | `prod` | Build mode. |
| `clean` | `fresh`, `clean` | `fresh` | `fresh` removes any existing build directory and starts over; `clean` runs a clean rebuild against the existing build directory. |

**Example:**
```
./compiletrkr.sh hera gcc debug clean
```
This compiles on Hera using the gcc compiler, in debug mode, doing a clean rebuild.

A log file for each compile attempt is saved automatically (the path is printed at the end of the run).

⚠️ The script's help text (`./compiletrkr.sh --help`) currently lists `container` and `personal` as system options. **These are not yet functional** — they're planned for a future release to support non-RDHPC users. Ignore these two options for now.

### 4.2.2 Spack

If you don't have RDHPC access, you can install the tracker's dependencies locally using a software package manager such as [Spack](https://spack.io/).

⚠️ **Note:** Comprehensive, step-by-step Spack installation instructions for the tracker are still being developed and will be added soon. In the meantime, what's below is an example starting point based on the dependency list used to build the project's own container image, rather than a complete, official walkthrough.

The project's own container image (see 4.2.4) is built from a `spack.yaml` environment file, which lists the authoritative set of dependencies:

```yaml
specs:
  - gcc@14.2.0
  - mpich
  - bacio
  - cmake
  - g2c
  - g2
  - g2tmpl
  - hdf5 ^mpich
  - jasper
  - libpng
  - netcdf-c ^hdf5
  - netcdf-fortran ^hdf5
  - w3emc
  - zlib
  - libyaml
  - grib-util
  - wgrib2
  - nco
  - cdo
```

If you have Spack installed locally, you can use this same spec list as an example starting point for building your own environment (e.g. `spack install <package>` for each entry, or adapting this into your own `spack.yaml` environment) until fuller instructions are available. The container build targets Rocky Linux 9 with GCC 14.2.0; your own system's OS and compiler may require adjustments.

There is currently no `compiletrkr.sh`-equivalent for Spack-based or other non-RDHPC installs — once these dependencies are available on your system, you'll build using `cmake` directly (see 4.3).

### 4.2.3 Manual Installation

It's technically possible to install all of the tracker's library dependencies by hand, without using a package manager like Spack or Conda. **This is not recommended** and has not been tested by the tracker's maintainers — beyond the general fragility of manually managing scientific software dependencies, correctly linking libraries so the tracker's build can find and use them requires nontrivial systems knowledge that most users won't have readily available.

If you choose this route, you're on your own: use the dependency list in 4.2.2 as a reference for what's required, but expect to troubleshoot library paths, versions, and linker configuration yourself.

### 4.2.4 Containerized Environment

The repository provides a GCC-based container image, currently used to support its continuous integration and continuous deployment (CI/CD) workflows:

```
ghcr.io/noaa-gfdl/gfdl-vortextracker/vortex-ci-gnu:gcc14.2.0_spackv1.2
```

⚠️ **Important:** This container is currently intended primarily for development and testing. It is **not yet configured to provide a streamlined execution workflow** — it doesn't use `compiletrkr.sh`, and there isn't yet a polished, user-facing path for building and running the tracker inside it.

**Steps:**

1. Pull the container image:
   ```
   docker pull ghcr.io/noaa-gfdl/gfdl-vortextracker/vortex-ci-gnu:gcc14.2.0_spackv1.2
   ```
2. Run the container and get a shell inside it:
   ```
   docker run -it ghcr.io/noaa-gfdl/gfdl-vortextracker/vortex-ci-gnu:gcc14.2.0_spackv1.2 /bin/bash
   ```
3. The container does not come with the Vortex Tracker source code included — clone the repository from inside the container (see 4.1), then navigate to the source directory:
   ```
   cd GFDL-VortexTracker/compile/src_code
   ```
4. Build using `cmake` directly (see 4.3).

**What's coming:** Future releases will expand support for containerized environments by providing a more user-friendly execution workflow, making it easier to build and run the tracker on non-NOAA systems while maintaining portability and reproducibility across computing platforms. The `container`/`personal` options referenced in `compiletrkr.sh`'s help text (see 4.2.1) are planned for this purpose but are not yet functional.

## 4.3 Build and Compile the Tracker

- **NOAA RDHPCS:** compilation is handled entirely by `compiletrkr.sh` (4.2.1) — no manual `cmake`/`make` steps are needed.
- **Container environment:** once inside the container with the repository cloned (4.2.4), build manually:
  ```
  cd compile/src_code
  mkdir -p build && cd build
  cmake -DCMAKE_PREFIX_PATH="/opt/views/view/" ..
  make
  ```
- **Spack / Manual installations:** once your dependencies are installed and available on your system, build the same way:
  ```
  cd compile/src_code
  mkdir -p build && cd build
  cmake ..
  make
  ```
  You may need to pass additional `-D` flags to `cmake` depending on where your dependencies are installed (see the container's `-DCMAKE_PREFIX_PATH` example above for the general idea).

## 4.4 Verify the Installation

After the build process completes, confirm the executables were built:

```
cd compile/src_code
ls exec/
```

**Expected outcome:** The `exec/` directory exists and contains the tracker executables.

For RDHPC builds specifically, `compiletrkr.sh` will report `COMPILATION SUCCESSFUL` when the build finishes. If `exec/` is missing, the build did not complete successfully — check the log file referenced in the script's output (RDHPC) or your terminal output (container/manual builds) for errors.


# 5. Configuring and Running the Tracker

## 5.1 Input Data Overview

The tracker consumes meteorological model output in one of two formats — NetCDF or GRIB (GRIB1 or GRIB2) — along with a set of runtime configuration files you fill out before running. Which files you need to configure depends on your data format and which optional diagnostics (e.g. vortex tilt) you're using. All of the scripts below are written for and expect a bash shell.

## 5.2 Fill Out the init_data Files

Navigate to the init_data directory:

```
cd run/init_data
```

Aside from `example_file.txt` (a reference-only template — see below), these files are intentionally left blank in the repository, and you'll need to populate them yourself with the values needed for your run. Which files you need depends on your data format and whether you're using the vortex tilt parameter:

| File | Who needs to fill it out |
|---|---|
| `leadtimes.txt` | Everyone (NetCDF and GRIB users) |
| `hgt_levs.txt` | GRIB users |
| `tmp_levs.txt` | GRIB users |
| `vortex_tilt_levs.txt` | Anyone using the vortex tilt parameter (NetCDF or GRIB) |
| `vortex_tilt_vars.txt` | NetCDF users using the vortex tilt parameter |

⚠️ **Formatting is critical.** These files use fixed-width columns that the tracker reads by character position — not by comma, tab, or other delimiter. For example, `leadtimes.txt` uses a 4-character right-justified index column followed by a 6-character right-justified value column (10 characters per row total):

```
   1     0
   2   360
   3   720
  ...
  29 10080
```

When filling out any of these files:
1. Don't add, remove, or shift spaces — keep values right-justified within their column width.
2. Don't use commas, tabs, or other delimiters between columns.
3. Add as many rows as needed for your data, but keep every row the same fixed width.
4. The first integer (row index) must start in column 3.

`run/init_data/example_file.txt` is a reference-only file showing this formatting (it is not itself a config file the tracker reads) — check it for a quick reminder while you're filling out the files above.

## 5.3 Edit the Setup Script

Navigate to the subdirectory matching your model data's format:

```
cd ../scripts/netcdf       # if your model data is NetCDF
# or
cd ../scripts/grib         # if your model data is GRIB1 or GRIB2
```

Each directory contains a setup script (`setup_netcdf.sh` or `setup_grib.sh`) that acts as your run's configuration file — this is the main file you'll modify before executing a run. The script itself is commented throughout, with instructions on exactly how each variable should be declared; a few of the most commonly used variables are:

| Variable | Description |
|---|---|
| `datadir` | Where your data files are stored |
| `initymdh` | Initialization forecast date/time (`yyyymmddhh`) |
| `lead_time_units` | Time units used in your data files |
| `atcfname` | 4-character ATCF model name |
| `trkrtype` | `tracker` for known storms, or `tcgen` for genesis runs |
| `tcvitals_file` | Path to an existing tcvitals file, or leave blank to auto-generate one |

GRIB-specific variables also include `gribver` (1 or 2) and `file_sequence` (`multi` vs. `onebig`). NetCDF-specific variables include `ncdf_filename`. For the full set of configurable variables and how to declare them, refer to the comments within the setup script itself.

## 5.4 NetCDF Variable Mapping (atmos_netcdfvars.sh)

If your data is NetCDF, you must **also** edit a second file in the same directory: `atmos_netcdfvars.sh`. This file maps the meteorological variable names used by the tracker's source code (e.g. sea level pressure, wind components at various pressure levels, geopotential height, temperature, humidity) to the actual variable names used in your specific data file, since NetCDF files vary in naming conventions.

This step is unique to NetCDF users. GRIB users don't need an equivalent file because GRIB variable naming is standardized across GRIB files — unlike NetCDF, where the same meteorological variable can be named differently from one file to the next.

All variables in this file default to `'X'` — if your data doesn't include a given variable (e.g. temperature at 600mb), leave it set to `'X'`; otherwise, replace `'X'` with the matching variable name from your file.

⚠️ **Important:** Once you've finished editing this file, you must change:
```
export usercheck='NOTCHECKED'
```
to:
```
export usercheck='CHECKED'
```
This is a deliberate failsafe — if `usercheck` is left as `'NOTCHECKED'`, the run script will intentionally break rather than run with unverified variable mappings.

## 5.5 Supported Formats

| Format | Notes |
|---|---|
| NetCDF | Requires `atmos_netcdfvars.sh` variable mapping (5.4) in addition to the setup script |
| GRIB1 | Set `gribver=1` in `setup_grib.sh` |
| GRIB2 | Set `gribver=2` in `setup_grib.sh` |

## 5.6 Execute the Run

Once your setup script (and, for NetCDF, `atmos_netcdfvars.sh`) is fully configured, launch the tracker either directly or via a batch job.

⚠️ Runtime execution documentation currently focuses on NOAA RDHPCS. A dedicated non-RDHPC execution workflow is not yet documented — see Chapter 4 for the non-RDHPC build methods currently available.

**Option A: Direct execution**

Run the script directly from within its directory:

```
./setup_netcdf.sh
```

It's recommended to capture standard output to a log file for later review, e.g. using `tee`:

```
./setup_netcdf.sh | tee run.log
```

(Use whichever logging approach you prefer — `tee`, output redirection, etc.)

**Option B: Batch submission**

You can also submit the script as a batch job through your RDHPC system's scheduler (e.g. Slurm, PBS). Since scheduler directives and submission commands vary by system, consult your specific RDHPC system's documentation for the correct batch script header and submission command (e.g. `sbatch` for Slurm-based systems).

See Chapter 6 (Output Files) for what to expect once the run completes.


# 6. Output Files

## 6.1 Output Directory

Tracker output is written to a working directory built from your run's configuration:

```
${workdir}/${today_stamp}/${atcfname}.${pdy}/
```

> **Note on format:** All of the tracker's output files use the Automated Tropical Cyclone Forecasting System (ATCF) format — a standardized ASCII format originally developed at the Naval Research Laboratory and used across the National Hurricane Center and Joint Typhoon Warning Center for storm track and intensity data. This is a hurricane-forecasting-specific format, separate from the general-purpose NetCDF/GRIB formats used for the tracker's *input* data. Further documentation on ATCF format specifics is available from NHC and Navy resources online.

## 6.2 Generated Products

### Core Output (Every Run)

These files are generated for every run, regardless of configuration (filenames use your configured `atcfname` and the run's `ymdh` timestamp):

| File | Description |
|---|---|
| `trak.<atcfname>.all.<ymdh>` | All track records |
| `trak.<atcfname>.atcf.<ymdh>` | Track in ATCF format |
| `trak.<atcfname>.atcfunix.<ymdh>` | Track in ATCF Unix format |
| `trak.<atcfname>.atcfunix_ext.<ymdh>` | Extended ATCF Unix format |
| `trak.<atcfname>.atcf_hfip.<ymdh>` | Track in HFIP format |
| `trak.<atcfname>.parmfix.<ymdh>` | Fixed parameters |

If you set `trkrtype=tcgen` (genesis run) rather than `trkrtype=tracker`, you'll additionally get:

| File | Description |
|---|---|
| `trak.<atcfname>.atcf_gen.<ymdh>` | Genesis-specific ATCF track |

### Additional Output (Enabled by Default)

Two diagnostics are turned on by default in `run/subscripts/trkrvars.sh` (`phaseflag='y'` and `structflag='y'`), so most runs will also produce:

| File | Description |
|---|---|
| `trak.<atcfname>.cps_parms.<ymdh>` | Cyclone phase space parameters |
| `trak.<atcfname>.structure.<ymdh>` | Storm structure diagnostics |
| `trak.<atcfname>.fractwind.<ymdh>` | Fractional wind coverage |
| `trak.<atcfname>.pdfwind.<ymdh>` | Wind probability distribution |

### Additional Output (Opt-In)

| File | Generated when... |
|---|---|
| `output_genvitals.<atcfname>.<ymdh>` | `write_vit='y'` (default is `'n'`; requires editing `trkrvars.sh` directly) |
| `trak.<atcfname>.vortex_tilt.<ymdh>` | `vortex_tilt_flag='y'` in your setup script |

> **Note:** Which of these output files is most relevant depends on your use case; a full breakdown of primary vs. supplementary/diagnostic output for typical workflows is pending further review.

## 6.3 Log Files

- **Build logs:** a log file for each compile attempt is saved automatically by `compiletrkr.sh` (see 4.2.1); its path is printed at the end of the build.
- **Run logs:** if you used direct execution with output redirection (e.g. `./setup_netcdf.sh | tee run.log`, see 5.6), your run's standard output is captured in that log file. Batch-submitted runs will follow your RDHPC scheduler's standard logging conventions (e.g. Slurm's `slurm-<jobid>.out`).


# 7. Troubleshooting

## 7.1 Build Issues

| Symptom | Cause / Resolution |
|---|---|
| `compile/src_code/exec/` directory does not exist after building | Build did not complete successfully. Check the build log (RDHPC: path printed by `compiletrkr.sh`; container/manual: terminal output) for the specific compiler or linker error. |

*(Additional common build failures, compiler errors, and dependency problems to be documented.)*

## 7.2 Runtime Issues

| Symptom | Cause / Resolution |
|---|---|
| Run script exits/breaks immediately for NetCDF data | Check that `usercheck` in `atmos_netcdfvars.sh` is set to `'CHECKED'` (not the default `'NOTCHECKED'`) — see 5.4. This is an intentional failsafe, not a bug. |
| Tracker misreads `leadtimes.txt` or other `init_data/` files | Check fixed-width column formatting — see 5.2. A single misplaced space will cause the tracker to misread these files. |

*(Additional common runtime failures and recommended troubleshooting steps to be documented.)*

## 7.3 Frequently Asked Questions

*(To be completed as common user questions arise.)*


# 8. Additional Resources

## 8.1 GitHub Repository

Official GFDL Vortex Tracker GitHub repository: https://github.com/NOAA-GFDL/GFDL-VortexTracker

## 8.2 Documentation

Additional reference documentation is maintained within the repository's `docs/` directory:

- `docs/genesisdoc.md` — details on the tracker's genesis detection (`tcgen`) mode
- `docs/radiidoc.md` — details on the wind radii and axisymmetric RMW diagnostic schemes

## 8.3 Contributing

The repository does not currently include a CONTRIBUTING file. Check the GitHub repository directly for the most current guidance on submitting issues or contributions.