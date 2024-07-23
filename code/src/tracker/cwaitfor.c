#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <stdint.h>
#include <time.h>

void c_run_command(int64_t *retval,char *cmd) {
  *retval=system(cmd);
}

void cwaitfor(int64_t *status, int64_t *minage, int64_t *minsize, int64_t *maxwait,
              int64_t *sleeptime, char *filename) {
  struct stat s;
  time_t now=time(NULL);
  int64_t maxwaitv=*maxwait;
  int64_t size,age;
  fprintf(stderr,"%s: cwaitfor with minage=%d minsize=%d maxwait=%d=%d sleeptime=%d\n",
          filename,*minage,*minsize,*maxwait,maxwaitv,*sleeptime);
  while(maxwaitv<0 || time(NULL)-now<maxwaitv) {
    if(!stat(filename,&s)) {
      size=s.st_size;
      age=time(NULL)-s.st_mtime;
      if(size>=*minsize && age>*minage) {
        fprintf(stderr,"%s: ready.\n",filename);
        *status=0;
        return;
      } else {
        fprintf(stderr,"%s: Not ready yet.  Size=%d, age=%d, min size=%d, min age=%d\n",
               filename,size,age,*minsize,*minage);
      }
    } else {
      fprintf(stderr,"%s: cannot stat: %d\n",filename,errno);
    }
    fprintf(stderr,"%s: sleep %d\n",filename,*sleeptime);
    sleep(*sleeptime);
  }

  *status=1;
  return;
}

void c_run_command_(int64_t*r,char*c) { c_run_command(r,c); }
void c_run_command__(int64_t*r,char*c) { c_run_command(r,c); }
void C_RUN_COMMAND(int64_t*r,char*c) { c_run_command(r,c); }
void C_RUN_COMMAND_(int64_t*r,char*c) { c_run_command(r,c); }
void C_RUN_COMMAND__(int64_t*r,char*c) { c_run_command(r,c); }

void cwaitfor_(int64_t*a,int64_t*b,int64_t*c,int64_t*d,int64_t*e,char*f) {
  cwaitfor(a,b,c,d,e,f);
}

void cwaitfor__(int64_t*a,int64_t*b,int64_t*c,int64_t*d,int64_t*e,char*f) {
  cwaitfor(a,b,c,d,e,f);
}

void CWAITFOR(int64_t*a,int64_t*b,int64_t*c,int64_t*d,int64_t*e,char*f) {
  cwaitfor(a,b,c,d,e,f);
}

void CWAITFOR_(int64_t*a,int64_t*b,int64_t*c,int64_t*d,int64_t*e,char*f) {
  cwaitfor(a,b,c,d,e,f);
}

void CWAITFOR__(int64_t*a,int64_t*b,int64_t*c,int64_t*d,int64_t*e,char*f) {
  cwaitfor(a,b,c,d,e,f);
}
