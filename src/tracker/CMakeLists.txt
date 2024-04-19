#----------------------------------------------------------
# Last edited by: Caitlyn Mcallister
# Originated by: Biju Thomas
# Email: caitlyn.mcallister@noaa.gov
#        timothy.marchok@noaa.gov
#----------------------------------------------------------

set(tracker_srcs
  gettrk_modules.f 
  module_waitfor.f 
  cwaitfor.c
  gettrk_main.f)

set(exe_name gettrk.x) 
set(exec_dir ${CMAKE_SOURCE_DIR}/exec)

if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel)$")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O2 -fp-model precise -i4 -r8")
endif()

add_executable(${exe_name} ${tracker_srcs})

IF(DEFINED hwrf_g2_inc)
  target_include_directories(
  ${exe_name} PUBLIC
  ${hwrf_g2_inc})
ELSE()
  target_include_directories(
  ${exe_name} PUBLIC
  w3emc_d
  g2_d
  sigio_4)
ENDIF()

IF(DEFINED hwrf_g2_lib)
  target_link_libraries(
  ${exe_name}
  NetCDF::NetCDF_Fortran
  w3emc::w3emc_d
  w3nco::w3nco_d
  bacio::bacio_4
  ${hwrf_g2_lib}
  ${JASPER_LIBRARIES}
  ${PNG_LIBRARIES})
ELSE()
  target_link_libraries(
  ${exe_name}
  NetCDF::NetCDF_Fortran
  w3emc::w3emc_d
  g2::g2_d
  w3nco::w3nco_d
  bacio::bacio_4
  ${JASPER_LIBRARIES}
  ${PNG_LIBRARIES})
ENDIF()


install(TARGETS ${exe_name} DESTINATION ${exec_dir})
