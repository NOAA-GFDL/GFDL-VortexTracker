# Copyright 2013-2022 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

# ----------------------------------------------------------------------------
# If you submit this package back to Spack as a pull request,
# please first remove this boilerplate and all FIXME comments.
#
# This is a template package file for Spack.  We've put "FIXME"
# next to all the things you'll want to change. Once you've handled
# them, you can save this file and test your package like this:
#
#     spack install gfdl-vortextracker
#
# You can edit this file again by typing:
#
#     spack edit gfdl-vortextracker
#
# See the Spack documentation for more information on packaging.
# ----------------------------------------------------------------------------

from spack.package import *


class GfdlVortextracker(CMakePackage):
    """The GFDL vortex tracker created by Tim Marchok."""

    # FIXME: Add a proper url for your package's homepage here.
    homepage = "https://github.com/NOAA-GFDL/GFDL-VortexTracker"
    url = "https://github.com/underwoo/GFDL-VortexTracker/archive/refs/heads/cmake.zip"
    git = "https://github.com/underwoo/GFDL-VortexTracker.git"

    maintainers = ["underwoo"]

    # FIXME: Add proper versions and checksums here.
    version("cmake", branch="cmake")

    depends_on("netcdf-fortran")
    depends_on("bacio")
    depends_on("w3emc")
    depends_on("g2")
