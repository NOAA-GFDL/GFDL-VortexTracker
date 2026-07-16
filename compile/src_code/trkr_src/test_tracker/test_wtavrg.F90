program test_subroutine_wtavrg

  use access_subroutines

  implicit none

  integer            :: test_kmax
  real, dimension(4) :: test_xdat, test_wt
  real               :: test_xwtavg, expected_xwtavg
  integer            :: iwtret

  test_kmax = 4
  test_xdat = (/2.0, 4.0, 6.0, 8.0/)
  test_wt = 1.0
  expected_xwtavg = 5.0

  call wtavrg(test_xdat, test_wt, test_kmax, test_xwtavg, iwtret)

  if (test_xwtavg .ne. expected_xwtavg) then
    write(*,*) "Error in test wxtavrg"
    write(*,*) "Expected ", expected_xwtavg, " but got ", test_xwtavg
    error stop
  endif

end program test_subroutine_wtavrg