program test_subroutine_get_sfc_center

  use access_subroutines

  implicit none
  !subroutine get_sfc_center (xmeanlon,xmeanlat,clon
  !  &                  ,clat,ist,ifh,calcparm,xsfclon,xsfclat
  !  &                  ,maxstorm,igscret)
  integer, parameter :: maxstorm = 2, maxtime = 2, maxtp = 2
  integer    :: ist,ifh,igscret
  real       :: clon(maxstorm,maxtime,maxtp)
  real       :: clat(maxstorm,maxtime,maxtp)
  real       :: xmeanlon,xmeanlat
  real       :: xsfclon,xsfclat
  logical(1) :: calcparm(maxtp,maxstorm)

  xmeanlon = 200.0
  xmeanlat = 20.0
  clon     = 0.0
  clat     = 0.0

  ist = 20
  ifh = 200
  calcparm = .true.

  call get_sfc_center(xmeanlon, xmeanlat, clon, clat, ist, ifh, calcparm, &
                      xsfclon, xsfclat, maxstorm, igscret)

  print *, xsfclon, xsfclat, igscret

end program test_subroutine_get_sfc_center