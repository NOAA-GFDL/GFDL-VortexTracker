#----------------------------------------------------------
# Last edited by: Caitlyn Mcallister
# Originated by: Biju Thomas
# Email: caitlyn.mcallister@noaa.gov
#        timothy.marchok@noaa.gov
#----------------------------------------------------------

# fortran flags
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O2 -fp-model precise -i4 -r8")

# set up build for supvit support code
set(supvit_srcs
  supvit/supvit_main.f
  supvit/supvit_modules.f
  CACHE INTERNAL "")

add_executable(supvit.x ${supvit_srcs})

target_link_libraries(
  supvit.x
  g2::g2_d
  bacio::bacio_4
  w3emc::w3emc_d)

install(TARGETS supvit.x DESTINATION ${CMAKE_SOURCE_DIR}/exec)

# set up build for tave support code
set(tave_srcs
	tave/tave.f
	CACHE INTERNAL "")

add_executable(tave.x ${tave_srcs})

target_link_libraries(
  tave.x
  g2::g2_d
  bacio::bacio_4
  w3emc::w3emc_d)

install(TARGETS tave.x DESTINATION ${CMAKE_SOURCE_DIR}/exec)

# set up build for vint support code
set(vint_srcs
        vint/vint.f
        CACHE INTERNAL "")

add_executable(vint.x ${tave_srcs})

target_link_libraries(
  vint.x
  g2::g2_d
  bacio::bacio_4
  w3emc::w3emc_d)

install(TARGETS vint.x DESTINATION ${CMAKE_SOURCE_DIR}/exec)
