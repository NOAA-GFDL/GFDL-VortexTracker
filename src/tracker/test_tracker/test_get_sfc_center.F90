program test_subroutine_get_sfc_center

  implicit none
  !subroutine get_sfc_center (xmeanlon,xmeanlat,clon
  !  &                  ,clat,ist,ifh,calcparm,xsfclon,xsfclat
  !  &                  ,maxstorm,igscret)
  integer, parameter :: maxstorm = 2000, maxtime = 500, maxtp = 14
  integer    :: ist,ifh,igscret
  real       :: clon(maxstorm,maxtime,maxtp)
  real       :: clat(maxstorm,maxtime,maxtp)
  real       :: xmeanlon,xmeanlat
  real       :: xsfclon,xsfclat
  logical(1) :: calcparm(maxtp,maxstorm)

  xmeanlon = 200.0
  xmeanlat = 20.0
  clon     = 210.0
  clat     = 30.0

  ist = 2
  ifh = 1
  calcparm = .true.



end program test_subroutine_get_sfc_center