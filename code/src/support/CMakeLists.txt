#----------------------------------------------------------
# Last edited by: Caitlyn Mcallister
# Originated by: Biju Thomas
# Email: caitlyn.mcallister@noaa.gov
#        timothy.marchok@noaa.gov
#----------------------------------------------------------

# set fortran compiler flags
get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)
if (Fortran_COMPILER_NAME MATCHES "gfortran.*")
  set (CMAKE_Fortran_FLAGS "-Wall -Wextra")                 # gcc fortran compiler flags here
elseif (Fortran_COMPILER_NAME MATCHES "ifx.*")
  set (CMAKE_Fortran_FLAGS "-fp-model=precise -i4 -r8")     # ifx fortran compiler flags here
endif()

# debug mode
set (CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0")

# set up build for supvit support code
set(supvit_srcs
  supvit/supvit_main.f
  supvit/supvit_modules.f
  CACHE INTERNAL "")

add_executable(supvit.x ${supvit_srcs})

target_link_libraries(
  supvit.x
  g2::g2_d)

install(TARGETS supvit.x DESTINATION ${CMAKE_SOURCE_DIR}/exec)

# set up build for tave support code
set(tave_srcs
	tave/tave.f
	CACHE INTERNAL "")

add_executable(tave.x ${tave_srcs})

target_link_libraries(
  tave.x
  g2::g2_d)

install(TARGETS tave.x DESTINATION ${CMAKE_SOURCE_DIR}/exec)

# set up build for vint support code
set(vint_srcs
        vint/vint.f
        CACHE INTERNAL "")

add_executable(vint.x ${tave_srcs})

target_link_libraries(
  vint.x
  g2::g2_d)

install(TARGETS vint.x DESTINATION ${CMAKE_SOURCE_DIR}/exec)
