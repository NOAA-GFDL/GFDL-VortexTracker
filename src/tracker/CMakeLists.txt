#----------------------------------------------------------
# Last edited by: Caitlyn Mcallister
# Originated by: Biju Thomas
# Email: caitlyn.mcallister@noaa.gov
#        timothy.marchok@noaa.gov
#----------------------------------------------------------

set(tracker_src
  gettrk_main.f
  gettrk_modules.f
  module_waitfor.f
  cwaitfor.c
  CACHE INTERNAL "")

add_executable(gettrk.x ${tracker_src})

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