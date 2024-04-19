#----------------------------------------------------------
# Last edited by: Caitlyn Mcallister
# Originated by: Biju Thomas
# Email: caitlyn.mcallister@noaa.gov
#        timothy.marchok@noaa.gov
#----------------------------------------------------------

# set up build for supvit support code
set(supvit_srcs
  supvit/supvit_main.f
  supvit/supvit_modules.f
  CACHE INTERNAL "")

add_executable(supvit.x ${supvit_srcs})

target_include_directories(
  supvit.x PUBLIC
  w3emc
  g2)