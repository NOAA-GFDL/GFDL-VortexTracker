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

# add if statement in case user is using gcc
if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel)$")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O2 -fp-model precise -i4 -r8")
endif()

target_link_libraries(
  gettrk.x
  g2::g2_d
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
  NetCDF::NetCDF_Fortran
  ${JASPER_LIBRARIES}
  ${PNG_LIBRARIES})

# create test executables
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/src/tracker/exec) # put any build executables in exec directory

add_executable(calccorr.x test_tracker/test_calccorr.F90)
target_link_libraries(calccorr.x PRIVATE subroutine_lib)

add_executable(test_avgcalc.x test_tracker/test_avgcalc.F90)
target_link_libraries(test_avgcalc.x PRIVATE subroutine_lib)

add_executable(test_calc_vmag.x test_tracker/test_calc_vmag.F90)
target_link_libraries(test_calc_vmag.x PRIVATE subroutine_lib)

add_executable(test_getcorr.x test_tracker/test_getcorr.F90)
target_link_libraries(test_getcorr.x PRIVATE subroutine_lib)

add_executable(test_stdevcalc.x test_tracker/test_stdevcalc.F90)
target_link_libraries(test_stdevcalc.x PRIVATE subroutine_lib)

add_executable(test_wtavrg_lon.x test_tracker/test_wtavrg_lon.F90)
target_link_libraries(test_wtavrg_lon.x PRIVATE subroutine_lib)

add_executable(test_wtavrg.x test_tracker/test_wtavrg.F90)
target_link_libraries(test_wtavrg.x PRIVATE subroutine_lib)

# unit test suit
add_test(test_calccorr ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/calccorr.x)
add_test(test_avgcalc ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_avgcalc.x)
add_test(test_calc_vmag ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_calc_vmag.x)
add_test(test_getcorr ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_getcorr.x)
add_test(test_stdevcalc ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_stdevcalc.x)
add_test(test_wtavrg_lon ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_wtavrg_lon.x)
add_test(test_wtavrg ${subroutine_lib} ${CMAKE_BINARY_DIR}/src/tracker/exec/test_wtavrg.x)
