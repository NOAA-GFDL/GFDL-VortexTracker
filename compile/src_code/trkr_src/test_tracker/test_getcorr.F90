!************************************************
!* This test program tests multiple subroutines from gettrk_main.f
!* Those subroutines are: getmean, getdiff, getslope, getyestim,
!* getresid, and getcorr
!*
!* Created by: Caitlyn McAllister
!* Email: caitlyn.mcalliser@noaa.gov
!************************************************
program test_subroutine_getcorr

  use access_subroutines

  implicit none

  integer, parameter :: test_inum = 4
  real               :: test_xarr(test_inum), test_yarr(test_inum)
  real               :: test_zmean, expected_zmean
  real               :: test_zdiff(test_inum), expected_zdiff(test_inum)
  real               :: test_slope, expected_slope
  real               :: test_yestim(test_inum), expected_yestim(test_inum)
  real               :: test_yint
  real               :: test_resid(test_inum), expected_resid(test_inum)
  real               :: test_r2, expected_r2

  !----------------------------------------------
  ! test the subroutine getmean
  test_xarr      = (/2.0, 4.0, 6.0, 8.0/)
  expected_zmean = 5.0

  call getmean(test_xarr, test_inum, test_zmean)

  if (test_zmean .ne. expected_zmean) then
    write(*,*) "Error in test getmean"
    write(*,*) "Expected ", expected_zmean, " but got ", test_zmean
    error stop
  endif

  !----------------------------------------------
  ! test subroutine getdiff
  expected_zdiff = (/-3.0, -1.0, 1.0, -3.0/)

  call getdiff(test_xarr, test_inum, test_zmean, test_zdiff)

  if (all(test_zdiff .ne. expected_zdiff)) then
    write(*,*) "Error in test getdiff"
    write(*,*) "Expected ", expected_zdiff, " but got ", test_zdiff
    error stop
  endif

  !----------------------------------------------
  ! test subroutine getslope
  test_yarr      = (/8.0, 10.0, 12.0, 14.0/)
  expected_slope = 2.0

  call getslope(test_xarr, test_yarr, test_inum, test_slope)

  if (test_slope .ne. expected_slope) then
    write(*,*) "Error in test getslope"
    write(*,*) "Expected ", expected_slope, " but got ", test_slope
    error stop
  endif

  !----------------------------------------------
  ! test subroutine getyestim
  test_yint       = 2.0
  expected_yestim = (/6.0, 10.0, 14.0, 18.0/)

  call getyestim(test_xarr, test_slope, test_yint, test_inum, test_yestim)

  if (all(test_yestim .ne. expected_yestim)) then
    write(*,*) "Error in test getyestim"
    write(*,*) "Expected ", expected_yestim, " but got ", test_yestim
    error stop
  endif

  !----------------------------------------------
  ! test subroutine getresid
  expected_resid = (/2.0, 0.0, -2.0, -4.0/)

  call getresid(test_yarr, test_yestim, test_inum, test_resid)
 
  if (all(test_resid .ne. expected_resid)) then
    write(*,*) "Error in test getyresid"
    write(*,*) "Expected ", expected_resid, " but got ", test_resid
    error stop
  endif

  !----------------------------------------------
  ! test subroutine getcorr

  ! test r2 = 0.0, no need to change other arrays
  ! with this test
  expected_r2 = 0.0
  call getcorr(test_resid, test_zdiff, test_inum, test_r2)

  if (test_r2 .ne. expected_r2) then
    write(*,*) "Error in test getcorr (r2 = 0)"
    write(*,*) "Expected ", expected_r2, " but got ", test_r2
    error stop
  endif

  ! test r2 = 1 - sumyresid / sumydiff
  test_resid  = 1.0
  test_zdiff  = 100.0
  expected_r2 = 0.9999

  call getcorr(test_resid, test_zdiff, test_inum, test_r2)

  if (test_r2 .ne. expected_r2) then
    write(*,*) "Error in test getcorr (r2 = 1 - sumyresid / sumydiff)"
    write(*,*) "Expected ", expected_r2, " but got ", test_r2
    error stop
  endif

  ! test r2 = 1.0
  test_resid  = 1.0
  test_zdiff  = 1.0E15
  expected_r2 = 1.0

  call getcorr(test_resid, test_zdiff, test_inum, test_r2)

  if (test_r2 .ne. expected_r2) then
    write(*,*) "Error in test getcorr (r2 = 1 - sumyresid / sumydiff)"
    write(*,*) "Expected ", expected_r2, " but got ", test_r2
    error stop
  endif

end program test_subroutine_getcorr