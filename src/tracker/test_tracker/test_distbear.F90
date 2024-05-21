program test_subroutine_distbear

  use access_subroutines

  implicit none

  real :: lon, clon, slon
  real :: lat, clat, slat
  real :: dist, cdist, sdist
  real :: bear, cbear, sbear
  real :: x, y, z, r
  real :: output_lon, output_lat
  real :: test_lon, test_lat
  real, parameter :: rad_earth_nm = 3440.170  ! radius of earth
  real, parameter :: rad_earth_km = 6372.797  ! radius of earth
  real, parameter :: pi = 4.0 * atan(1.0)   ! Both pi and dtr were declared in module 
  real, parameter :: dtr = pi / 180.0 

  lon = pi

  if (lon > 180.0) then
    lon = 360.0 - lon
  else
    lon = -1.0 * lon
  endif
  print *, lon

  lat = 90.0
  clat = cos(dtr * lat)
  slat = sin(dtr * lat)
  print *, "lats", clat, slat

  dist = pi
  cdist = cos(dist / rad_earth_km)
  sdist = sin(dist / rad_earth_km)
  print *, "dist", cdist, sdist

  clon = cos(dtr * lon)
  slon = sin(dtr * lon)
  print *, "lons", clon, slon

  bear = pi
  cbear = cos(dtr * bear)
  sbear = sin(dtr * bear)
  print *, "bears", cbear, sbear

  z = cdist * slat + clat * sdist * cbear
  y = clat * clon * cdist + sdist * (slon * sbear - slat * clon * cbear)
  x = clat * slon * cdist - sdist * (clon * sbear + slat * slon * cbear)

  r = sqrt(x**2 + y**2)
  print *, "R", r

  output_lat = atan2(z,r) / dtr
  print *, "output lat", output_lat

  if (r <= 0.0) then
    output_lon = 0.0
  else
    output_lon =  atan2(x,y) / dtr
    output_lon = mod(360.0 - output_lon,360.0)
  endif
  print *, "output lon", output_lon

  call distbear(lat, lon, dist, bear, test_lat, test_lon, "none")
  print *, "test_lat", test_lat
  print *, "test_lon", test_lon

end program test_subroutine_distbear