program test_subroutine_avgcalc

  use access_subroutines

  implicit none

  integer                  :: test_kmax
  real, dimension(4)       :: test_xdat
  logical(1), dimension(4) :: test_valid
  real                     :: test_xavg, expected_xavg
  integer                  :: iaret

  test_kmax     = 4
  test_xdat     = (/2.0, 4.0, 6.0, 8.0/)
  test_valid    = .true.
  expected_xavg = 5.0

  call avgcalc(test_xdat, test_kmax, test_valid, test_xavg, iaret)

  if (test_xavg .ne. expected_xavg) then
    write(*,*) "Error in test avgcalc"
    write(*,*) "Expected ", expected_xavg, " but got ", test_xavg
    error stop
  endif

end program test_subroutine_avgcalc