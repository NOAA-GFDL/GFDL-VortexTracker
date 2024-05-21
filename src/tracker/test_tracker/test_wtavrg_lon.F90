program test_subroutine_wtavrg_lon

  use access_subroutines

  implicit none

  integer            :: test_kmax
  real, dimension(4) :: test_xlon, test_wt
  real               :: test_xwtavg, expected_xwtavg
  integer            :: iwtret

  test_kmax = 4
  test_wt = 1.0
  expected_xwtavg = 5.0

  ! test xlon > 345.0
  test_xlon       = (/345.0, 350.0, 355.0, 360.0/)
  expected_xwtavg = 352.5

  call wtavrg_lon(test_xlon, test_wt, test_kmax, test_xwtavg, iwtret)

  if (test_xwtavg .ne. expected_xwtavg) then
    write(*,*) "Error in test wxtavrg_lon (xlon > 345.0)"
    write(*,*) "Expected ", expected_xwtavg, " but got ", test_xwtavg
    error stop
  endif

  ! test xlon < 15.0
  test_xlon       = (/0.0, 5.0, 10.0, 15.0/)
  expected_xwtavg = 7.5

  call wtavrg_lon(test_xlon, test_wt, test_kmax, test_xwtavg, iwtret)
  
  if (test_xwtavg .ne. expected_xwtavg) then
    write(*,*) "Error in test wxtavrg_lon (xlon < 15.0)"
    write(*,*) "Expected ", expected_xwtavg, " but got ", test_xwtavg
    error stop
  endif

end program test_subroutine_wtavrg_lon