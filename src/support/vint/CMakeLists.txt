#=======================================================================
#$$$ CMAKEFILE DOCUMENTATION BLOCK
# Biju Thomas
# Email: biju.thomas@noaa.gov
#=======================================================================

set(support_srcs
  vint.f)

set(exe_name vint.x)
set(exec_dir ${CMAKE_SOURCE_DIR}/exec)

if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel)$")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O2 -fp-model precise -i4 -r8")
endif()

add_executable(${exe_name} ${fortran_srcs})

target_include_directories(
  ${exe_name} PUBLIC
  w3emc::w3emc_d
  g2::g2_d
  sigio::sigio_4)

target_link_libraries(
  ${exe_name}
  w3emc::w3emc_d
  g2::g2_d
  w3nco::w3nco_d
  bacio::bacio_4)


install(TARGETS ${exe_name} DESTINATION ${exec_dir})
