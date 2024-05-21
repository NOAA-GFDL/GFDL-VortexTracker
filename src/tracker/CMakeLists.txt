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

add_executable(gettrk.x gettrk_main.f ${tracker_src})

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

#------------------------------------------------
# Everything below this is set up for unit testing


# create a different library for test executables
add_library(subroutine_lib ${tracker_src})

target_link_libraries(
  subroutine_lib
  g2::g2_d
  bacio::bacio_4
  w3emc::w3emc_d
  w3nco::w3nco_d
  NetCDF::NetCDF_Fortran
  ${JASPER_LIBRARIES}
  ${PNG_LIBRARIES})

# create test executables
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/src/tracker/exec) # put any build executables in exec directory

add_executable(test_getcorr.x test_tracker/test_getcorr.F90)
target_link_libraries(test_getcorr.x PRIVATE subroutine_lib)

add_executable(test_is_it_a_storm.x test_tracker/test_is_it_a_storm.F90)
target_link_libraries(test_is_it_a_storm.x PRIVATE subroutine_lib)

add_executable(test_get_sfc_center.x test_tracker/test_get_sfc_center.F90)
target_link_libraries(test_get_sfc_center.x PRIVATE subroutine_lib)

add_executable(test_distbear.x test_tracker/test_distbear.F90)
target_link_libraries(test_distbear.x PRIVATE subroutine_lib)

add_executable(test_wtavrg.x test_tracker/test_wtavrg.F90)
target_link_libraries(test_wtavrg.x PRIVATE subroutine_lib)

add_executable(test_wtavrg_lon.x test_tracker/test_wtavrg_lon.F90)
target_link_libraries(test_wtavrg_lon.x PRIVATE subroutine_lib)

add_executable(test_avgcalc.x test_tracker/test_avgcalc.F90)
target_link_libraries(test_avgcalc.x PRIVATE subroutine_lib)

add_executable(test_stdevcalc.x test_tracker/test_stdevcalc.F90)
target_link_libraries(test_stdevcalc.x PRIVATE subroutine_lib)

add_executable(test_calc_vmag.x test_tracker/test_calc_vmag.F90)
target_link_libraries(test_calc_vmag.x PRIVATE subroutine_lib)

# unit test suite
add_test(test_getcorr ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_getcorr.x)
add_test(test_is_it_a_storm ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_is_it_a_storm.x)
add_test(test_get_sfc_center ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_get_sfc_center.x)
add_test(test_distbear ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_distbear.x)
add_test(test_wtavrg ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_wtavrg.x)
add_test(test_wtavrg_lon ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_wtavrg_lon.x)
add_test(test_avgcalc ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_avgcalc.x)
add_test(test_stdevcalc ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_stdevcalc.x)
add_test(test_calc_vmag ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_calc_vmag.x)
