program test_subroutine_calc_vmag

  use access_subroutines

  implicit none

  integer, parameter        :: imx = 5, jmx = 5
  real, dimension(imx, jmx) :: test_xu, test_xv
  real, dimension(imx, jmx) :: test_wspeed, expected_wspeed
  integer                   :: icvret

  test_xu = 5.0
  test_xv = 5.0
  expected_wspeed = sqrt(50.0)

  call calc_vmag(test_xu, test_xv, imx, jmx, test_wspeed, icvret)

  if (all(test_wspeed .ne. expected_wspeed)) then
    write(*,*) "Error in test calc_vmag"
    write(*,*) "Expected ", expected_wspeed, " but got ", test_wspeed
    error stop
  endif

end program test_subroutine_calc_vmag