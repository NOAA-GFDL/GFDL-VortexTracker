program test_subroutine_is_it_a_storm

  use radii;     use grid_bounds;   use set_max_parms; use level_parms
  use trig_vals; use tracked_parms; use atcf;          use trkrparms; use access_subroutines

  implicit none

  integer, parameter :: imax = 5, jmax = 5
  real               :: dx, dy
  character(len=6)   :: cparm
  integer            :: ist
  logical(1)         :: defined_parm(imax, jmax)
  real               :: parmlon, parmlat, parmval
  character(len=1)   :: stormcheck
  integer            :: ifh
  integer            :: isiret

  type(trackstuff)   :: trkrinfo

  dx = 3.030395507812500E-002
  dy = 3.030204772949219E-002
  cparm = 'slp'
  ist = 3
  defined_parm = .true.
  parmlon = 288.9
  parmlat = 29.0
  parmval = 980.375298163757
  ifh = 1

  call is_it_a_storm(imax, jmax, dx, dy, cparm, ist, defined_parm, parmlon, parmlat, &
                     parmval, trkrinfo, stormcheck, ifh, isiret)

  print *, stormcheck

  ! is_it_a_storm calls ij_bounds so test is going to need to also call that with the correct
  ! parameters for is_it_a_storm to run all the way through?

end program test_subroutine_is_it_a_storm