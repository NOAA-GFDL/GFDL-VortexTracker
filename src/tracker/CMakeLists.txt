#----------------------------------------------------------
# Last edited by: Caitlyn Mcallister
# Originated by: Biju Thomas
# Email: caitlyn.mcallister@noaa.gov
#        timothy.marchok@noaa.gov
#----------------------------------------------------------

set(tracker_src
  gettrk_subroutines.f
  gettrk_modules.f
  module_waitfor.f
  cwaitfor.c
  CACHE INTERNAL "")

add_executable(gettrk.x gettrk_main.f${tracker_src})

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O2 -fp-model precise -i4 -r8")

target_link_libraries(
  gettrk.x
  g2::g2_d
  bacio::bacio_4
  w3emc::w3emc_d
  w3nco::w3nco_d
  NetCDF::NetCDF_Fortran
  ${JASPER_LIBRARIES}
  ${PNG_LIBRARIES})

install(TARGETS gettrk.x DESTINATION ${CMAKE_SOURCE_DIR}/exec)