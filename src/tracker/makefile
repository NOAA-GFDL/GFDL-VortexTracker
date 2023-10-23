SHELL   = /bin/sh
ISIZE   = 4
RSIZE   = 8
FCOMP   = ifort -nofree
CCOMP   = icc

INC_GRIB = /home/Timothy.Marchok/hur/trak/netcdf/include
INCNCDF = /app/spack/v0.15/linux-rhel7-x86_64/gcc-4.8.5/netcdf-fortran/4.5.2-q6uugfqsoid67nalgz5wn5lh4g2ufxaf/include
INCNCDC = /app/spack/v0.15/linux-rhel7-x86_64/gcc-4.8.5/netcdf-c/4.7.3-u3c3az7xj6sqrcpi5ft44otgm2ucd7lv/include
INCHDF  = /app/spack/v0.15/linux-rhel7-x86_64/gcc-4.8.5/hdf5/1.10.6-gtcsgptatc7pzbxxeqa456dicx22nb22/include

NCEP_GRIB_LIB_PATH = /home/Timothy.Marchok/hur/trak/netcdf/lib
NETCDF_FORTRAN_PATH = /app/spack/v0.15/linux-rhel7-x86_64/gcc-4.8.5/netcdf-fortran/4.5.2-q6uugfqsoid67nalgz5wn5lh4g2ufxaf/lib
NETCDF_C_PATH = /app/spack/v0.15/linux-rhel7-x86_64/gcc-4.8.5/netcdf-c/4.7.3-u3c3az7xj6sqrcpi5ft44otgm2ucd7lv/lib
HDF_PATH = /app/spack/v0.15/linux-rhel7-x86_64/gcc-4.8.5/hdf5/1.10.6-gtcsgptatc7pzbxxeqa456dicx22nb22/lib

LIBS    = -L$(NETCDF_FORTRAN_PATH)  \
             -lnetcdff  \
          -L$(NETCDF_C_PATH)  \
             -lnetcdf  \
          -L$(HDF_PATH)  \
             -lhdf5 -lhdf5_fortran -lhdf5_hl -lhdf5hl_fortran \
          -L$(NCEP_GRIB_LIB_PATH)  \
             -lg2 -lz -lpng -lw3_i4r8 -ljasper


LDFLAGS= 

FFLAGS= -pg -O2 -shared-intel -shared-libgcc -fp-stack-check -gen-interfaces -warn interfaces \
        -check all -debug all -traceback -heap-arrays 10 -init=zero -fno-omit-frame-pointer \
        -align  -I $(INC_GRIB) -I $(INCNCDF) -I $(INCNCDC) -I $(INCHDF) -integer-size 32 -real-size 32

CFLAGS= -pg -O2 -shared-intel -shared-libgcc -fno-omit-frame-pointer

gettrk:      gettrk_main.f gettrk_modules.o module_waitfor.o cwaitfor.o
	@echo " "
	@echo "  Compiling the main tracking program and subroutines....."
	$(FCOMP) $(FFLAGS) $(LDFLAGS) gettrk_modules.o \
             module_waitfor.o cwaitfor.o gettrk_main.f $(LIBS) -o gettrk
	@echo " "

cwaitfor.o: cwaitfor.c
	@echo " "
	@echo "  Compiling the waitfor C routine...."
	$(CCOMP) $(CFLAGS) -c cwaitfor.c -o cwaitfor.o

module_waitfor.o: module_waitfor.f
	@echo " "
	@echo "  Compiling the waitfor fortran module...."
	$(FCOMP) $(FFLAGS) -c module_waitfor.f -o module_waitfor.o

gettrk_modules.o:    gettrk_modules.f
	@echo " "
	@echo "  Compiling the regular tracker fortran modules....."
	$(FCOMP) $(FFLAGS) -c gettrk_modules.f -o gettrk_modules.o
	@echo " "

clean:
	-rm -f  *.o  *.mod *_genmod.f90
