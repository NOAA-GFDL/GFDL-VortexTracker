      MODULE module_waitfor
        implicit none
        private
        public :: waitfor, run_command

        integer(kind=8), parameter :: minage_def=30, minsize_def=1
     &                               ,maxwait_def=-1, sleeptime_def=3

      CONTAINS
        subroutine run_command(command,retval)
!         This routine uses the C system command to run a command.
!         This gets around any arbitrary command length limits in
!         fortran.
!         Also, this way we get the command return status.
          implicit none
          character(*), intent(in) :: command
          integer(kind=8), intent(out) :: retval
          call run_cmd_helper(trim(command)//char(0),                   &
     &len_trim(command)+1,retval)
        end subroutine run_command

        subroutine run_cmd_helper(cmd,cmdlen,retval)
          implicit none
          integer(kind=8), intent(in) :: cmdlen
          integer(kind=8), intent(out) :: retval
          character(*), intent(in) :: cmd(cmdlen)

          call c_run_command(retval,cmd)
        end subroutine run_cmd_helper

        subroutine waitfor(filename,status,minage,minsize,maxwait
     &                    ,sleeptime)
          implicit none
          character(*),intent(in) :: filename
          integer(kind=8), optional, intent(in) :: minage
          integer(kind=8), optional, intent(in) :: minsize
          integer(kind=8), optional, intent(in) :: maxwait
          integer(kind=8), optional, intent(in) :: sleeptime
          integer(kind=8), intent(out) :: status

          integer(kind=8) :: minage_in, minsize_in, maxwait_in
          integer(kind=8) :: sleeptime_in

          status=99

          if(present(minage)) then
             minage_in=minage
          else
             minage_in=minage_def
          endif

          if(present(minsize)) then
             minsize_in=minsize
          else
             minsize_in=minsize_def
          endif

          if(present(maxwait)) then
             maxwait_in=maxwait
          else
             maxwait_in=maxwait_def
          endif

          if(present(sleeptime)) then
             sleeptime_in=sleeptime
          else
             sleeptime_in=sleeptime_def
          endif

          call waitfor_helper(status,minage_in,minsize_in 
     &      ,maxwait_in,sleeptime_in,trim(filename),len_trim(filename))
        end subroutine waitfor

        subroutine waitfor_helper(status,minage,minsize
     &        ,maxwait,sleeptime,filename,N)
          integer(kind=8), intent(in) :: minage,minsize,maxwait
          integer(kind=8), intent(in) :: sleeptime,N
          character(len=N),intent(in) :: filename
          integer(kind=8), intent(out) :: status

          character(len=N+1) :: filename0
          character(len=1) :: null

          null=char(0)
          filename0=filename//null

          call cwaitfor(status,minage,minsize,maxwait,sleeptime
     &                 ,filename0)
        end subroutine waitfor_helper
      END MODULE module_waitfor
