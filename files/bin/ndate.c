#include "stdio.h" 
#include "string.h" 
#include "time.h"
#include "stdlib.h"
#include "ctype.h"

/* Program: ndate.c 
   Prgmmr:  Marchok       Date: 98-04-28 

   Abstract:  This program calculates a date given an initial date and 
     a number of hours to add or subtract.  Input 2-digit years > 50 
     are assumed to be 1951 <= yy <= 1999, while 2-digit years <= 50 
     are assumed to be 2000 <= yy <= 2050.

   3/99: Fixed 2 bugs. One bug was that the program would not catch
         invalid years (<1951 or >2050), the other bug was that if
         a 2-digit year was being output and the output year was 
         between 2000 & 2010, it would not print out the full 8 
         digits of the yymmddhh.

   Usage:   ndate.x [-h[elp]] [-g] [-y ndig] [fhour [idate]]

   Options:

    -h[elp]  Print this help message. 
    -g       Program uses the *current* time in GMT as the input
             date.  You CANNOT supply an idate AND use the -g option. 
    -y ndig  Force the number of digits that will appear in the 
             output year. ndig = 0,2 or 4, with 0 defaulting to 
             the number of digits in the input year.
    fhour    Integer number of hours to add or subtract to date. 
    idate    Input date.  Can be in either yymmddhh or yyyymmddhh 
             format.  If no input date is specified, then the 
             current system time is used.  You CANNOT supply an
             idate AND use the -g option.

   Functions called:
    check_args        Process input args and do rough error-checking
    check_valid_date  Make sure input idate is a valid date
    move_date         Calculate verifying date
    get_current_date  Get current system date/time
    check_leap        Check for leap year
    print_help        Print help message to stdout
    time              (External) Returns encoded calendar time of system
    localtime         (External) Returns a pointer to broken-down form of time
    gmtime            (External) Returns a pointer to broken-down form of gmt
*/

#define MAXYR 2050
#define MDY(ky)  ky*365 + ky/4 - ky/100 + ky/400

/* Declare Function prototypes.... */

char check_leap (int jyy);
unsigned long int  move_date (unsigned long int lymdh, int lenyy, int nhh, int *mt);
int  get_current_date (char ttype[]);
void check_args (int args, int *lenyyp, int *nhhp, unsigned long int *ymdhp, char *argvp[]);
void check_valid_date (unsigned long int inpymdh, char sname[]);
void print_help (char sname[]);

/*--------------------------------------------------------
/
/--------------------------------------------------------*/
int main (int argc, char * argv[])
{
  int  args,isecs,nhh,lenoutyy;
  int  mtc[13] = {365,396,59,90,120,151,181,212,243,273,304,334,365};
  unsigned long int iymdh,lymdh,newymdh;

  args = argc - 1;

  check_args (args,&lenoutyy,&nhh,&lymdh,argv);

  if (lymdh == 0) lymdh = get_current_date ("local");

  check_valid_date (lymdh,argv[0]);

  newymdh = move_date(lymdh,lenoutyy,nhh,mtc);

  if (lenoutyy == 4) printf ("%.10lu\n",newymdh);
  else               printf ("%.8lu\n",newymdh);

  exit (0);
}

/*--------------------------------------------------------
/
/--------------------------------------------------------*/
int get_current_date (char ttype[])
{
  /* This function returns the current system date in yyyymmddhh 
     format. Remember that the value for years returned from the 
     C time function is the number of years since 1900.  
  */
  struct tm *systime, *gmt;
  time_t t;

  t = time(NULL);

  if (!strcmp("local",ttype)) {
    systime = localtime(&t);
    return (1900 + systime->tm_year)*1000000 + (systime->tm_mon+1)*10000
           + (systime->tm_mday)*100 + systime->tm_hour;
  }
  else {
    gmt = gmtime(&t);
    return (1900 + gmt->tm_year)*1000000 + (gmt->tm_mon+1)*10000
           + (gmt->tm_mday)*100 + gmt->tm_hour;
  }
}

/*--------------------------------------------------------
/
/--------------------------------------------------------*/
char check_leap (int jyy)
{
  /* Check to see if year is a leap year.  jyy must be a 4-digit 
     year in order to properly use the 100- and 400-year tests. 
  */
  char checklp;

  if ((jyy % 4) != 0) return 'n';
  else  checklp = 'y';

  if ((jyy % 100) == 0) {
    if ((jyy % 400) == 0) checklp = 'y';
    else checklp = 'n';
  }

  return checklp;
}

/*--------------------------------------------------------
/
/--------------------------------------------------------*/
unsigned long int move_date (unsigned long int lymdh, int lenyy, int nhh, int *mt) 
{
  /* This function calculates the verifying date based on the number 
     of hours (nhh) added or subtracted to the input date (lymdh).  
     The logic in this function is identical to that in Mark 
     Iredell's MVDATE subroutine in /nwprod/w3libs/w3lib.source.
  */
  int  args,isecs,totalhh,ymdh;
  int  iyy,jyy,imm,idd,ihh;
  int  kdd,md,mday,jm,jd,jh;

  iyy = lymdh / 1000000;
  imm = (lymdh % 1000000) / 10000;
  idd = (lymdh % 10000) / 100;
  ihh = (lymdh % 100);

  if (iyy < 1000) jyy = MAXYR - ((MAXYR-iyy) % 100);
  else jyy = iyy;

  if (imm < 3) jyy = jyy - 1;

  totalhh = nhh + ihh;
  if (totalhh >= 0) kdd = totalhh / 24;
  else              kdd = (totalhh + 1)/24 - 1;

  jh   = totalhh - kdd*24;
  mday = MDY(jyy) + mt[imm-1] + idd + kdd;

  /*-----------------------------
      Get verifying date..... 
    -----------------------------*/

  jyy = mday / 365.2425;
  if (mday - (MDY(jyy)) <= mt[2]) jyy = jyy - 1;
  md = mday - (MDY(jyy));
  if (md > mt[0]) {
    jyy = jyy + 1;
    jm  = 2;
  }
  else jm = md/30 + 1;

  if (md - mt[jm-1] <= 0) jm = jm - 1;

  jd = md - mt[jm-1];

  if (jyy > MAXYR || jyy < (MAXYR - 100)) {
    printf ("ndate: The output year %d is out of range (can only be 1951-2050)\n",jyy);
    printf ("    ...You may have forgotten to enter an hour increment to add or subtract...\n");
    exit (3);
  }

  if (iyy < 1000) {
    if (lenyy == 4)
      return jyy*1000000 + jm*10000 + jd*100 + jh;
    else {
      return (jyy % 100)*1000000 + jm*10000 + jd*100 + jh;
    }
  }
  else {
    if (lenyy == 4 || lenyy == 0)
      return jyy*1000000 + jm*10000 + jd*100 + jh;
    else {
      return (jyy % 100)*1000000 + jm*10000 + jd*100 + jh;
    }
  }

}

/*--------------------------------------------------------
/
/--------------------------------------------------------*/
void check_args (int args, int *lenyyp, int *nhhp, unsigned long int *ymdhp, char *argvp[])
{
  /* This function processes the input arguments.  It also does rough 
     error checking, such as making sure numbers are entered for the 
     input date and number of hours, and making sure that valid options
     are entered for the -y option.
  */
  int  argctr,i,j,k,lenyyuser;
  unsigned long int iymdh;
  char gotnhh,gotyy,argstr[80],cymdh[10],gmtflag;

  gotnhh  = 'n';
  gotyy   = 'n';
  gmtflag = 'n';
  argctr = 1;
  *lenyyp = 2;  /* ...initialize lenyyp in case there's no -y option */
  *ymdhp  = 0;  /* ...initialize ymdhp in case there's no input date */
  *nhhp   = 0;  /* ...initialize nhhp in case there's no input number of hours to add/subtract */
  for (i = 1; i <= args; i++) {

    strcpy(argstr,argvp[i]);

    for (j = 0; j < strlen(argstr); j++) {
      argstr[j] = tolower(argstr[j]);
    }

    /* The following logic checks for and processes the 
       "-y" option.  The logic allows the option to be
       entered as either, for example "-y4" or "-y 4"  */

    if (argstr[0] == '-' && 
       (argstr[1] == 'y' || argstr[1] == 'g' || argstr[1] == 'h')) { 

      if (argstr[1] == 'y') {

        if (gotyy == 'n') gotyy = 'y';
        else {
          printf ("%s: Too many -y options listed\n",argvp[0]);
          printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",argvp[0]);
          exit (8);
        }
  
        if (strlen(argstr) > 2) {
          if      (argstr[2] == '0') *lenyyp = 0;
          else if (argstr[2] == '2') *lenyyp = 2;
          else if (argstr[2] == '4') *lenyyp = 4;
          else {
            printf ("%s: Invalid arguments to the -y option\n",argvp[0]);
            printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",argvp[0]);
            exit (8);
          }
        }
        else if (atoi(argvp[i+1]) == 0) {
          *lenyyp = 0;
          i++; 
        }
        else if (atoi(argvp[i+1]) == 2) {
          *lenyyp = 2;
          i++; 
        }
        else if (atoi(argvp[i+1]) == 4) {
          *lenyyp = 4;
          i++;  
        }
        else {
          printf ("%s: Invalid arguments to the -y option\n",argvp[0]);
          printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",argvp[0]);
          exit (8);
        }
  
        continue;
      }
      else if (argstr[1] == 'g') {
        gmtflag = 'y';
        continue;
      }
      else {
        print_help (argvp[0]);
        exit (1);
      }

    }

    /* This next part checks the remaining arguments after any "-y"
       option arguments, and makes sure that the remaining arguments
       (nhh and ymdh) are comprised of valid integer values.   */

    for (k = 0; k < strlen(argstr); k++) {
      if (k == 0) {
        if (argstr[0] == '-') {
          if (gotnhh == 'n') gotnhh = 'y';
          else {
            printf ("%s: gotnhh: Invalid argument is %s\n",argvp[0],argstr);
            printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",argvp[0]);
            exit (8);
          }
        }
        else if (!isdigit(argstr[0])) {
          printf ("%s: Invalid non-numeric character in %s\n",argvp[0],argstr);
          printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",argvp[0]);
          exit (8);
        }
      }
      else if (!isdigit(argstr[k])) {
        printf ("%s: Invalid non-numeric character in %s\n",argvp[0],argstr);
        printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",argvp[0]);
        exit (8);
      }
    }

    /* This next bit assumes the user knows what he is doing, and either 
       enters just an hour increment, or an hour increment along with an
       initial ymdh.  However, if the user enters just an initial ymdh, 
       then the following code will incorrectly assume that the value
       the user entered for the initial ymdh is actually the number of 
       hours to add, and you will wind up with an output date that is 
       out of the range of this program (>2050) 
    */

    if (argctr == 1) {
      *nhhp = atoi(argstr);
      argctr++;
    }
    else {
      strcpy (cymdh,argstr);
      lenyyuser = strlen(cymdh);
      iymdh     = atol(cymdh);
      *ymdhp    = iymdh;
    }

  }

  if (gmtflag == 'y') {
    if (*ymdhp > 0) {
      printf ("%s: You cannot specify a date with the -g option.\n",argvp[0]);
      printf ("          Only use -g to get the current GMT.    \n");
      printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",argvp[0]);
      exit (8);
    }
    else *ymdhp = get_current_date ("UTC");
  }

  /* If the user did not specify how many digits the output ymdh should
     have (with the -y option), then set the output length to the 
     default, which is the number of digits in the input ymdh.
  */

  if (gotyy == 'n') {
    if (lenyyuser == 10) *lenyyp = 4;
    else *lenyyp = 2;
  }

}

/*--------------------------------------------------------
/
/--------------------------------------------------------*/
void check_valid_date (unsigned long int inpymdh, char sname[])
{
  /* Verify input date is a valid date */

  int  iyy,jyy,imm,idd,ihh;

  iyy = inpymdh / 1000000;
  imm = (inpymdh % 1000000) / 10000;
  idd = (inpymdh % 10000) / 100;
  ihh = (inpymdh % 100);

  if (iyy < 1000) jyy = MAXYR - ((MAXYR-iyy) % 100);
  else jyy = iyy;

  /* First do some gross error checking to make sure that year,
     month, day and hour contain vaguely reasonable values (more
     refined checks for each month are done in the next section). */

  if (imm < 1 || imm > 12) {
    printf ("%s: Bad month in input date -- %lu\n",sname,inpymdh);
    printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",sname);
    exit (8);
  }
  if (idd < 1 || idd > 31) {
    printf ("%s: Bad day in input date -- %lu\n",sname,inpymdh);
    printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",sname);
    exit (8);
  }
  if (ihh < 0 || ihh > 23) {
    printf ("%s: Bad hour in input date -- %lu\n",sname,inpymdh);
    printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",sname);
    exit (8);
  }

  /* Now check the months that shouldn't have more than 30 days.... */

  if ((imm == 4 || imm == 6 || imm == 9 || imm == 11) && idd > 30) {
    printf ("%s: Invalid day for a 30-day month -- %lu\n",sname,inpymdh);
    printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",sname);
    exit (8);
  }

  /* Now check for the number of days in February, leap & non-leap years */

  if (imm == 2) {
    if (check_leap(jyy) == 'y' && idd > 29) {
      printf ("%s: Invalid day for leap year February -- %lu\n",sname,inpymdh);
      printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",sname);
      exit (8);
    }
    if (check_leap(jyy) == 'n' && idd > 28) {
      printf ("%s: Invalid day for non-leap year February -- %lu\n",sname,inpymdh);
      printf ("Usage: %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",sname);
      exit (8);
    }
  }

}

/*--------------------------------------------------------
/
/--------------------------------------------------------*/
void print_help (char sname[])
{
  printf ("\n %s: This program calculates a date given an initial\n",sname);
  printf ("          date and a number of hours to add or subtract.\n");
  printf ("          Input 2-digit years > 50 are assumed to be  \n"); 
  printf ("          1951 <= yy <= 1999, while 2-digit years <= 50 \n");
  printf ("          are assumed to be 2000 <= yy <= 2050. \n\n");
  printf (" Usage:   %s [-h[elp]] [-g] [-y ndig] [fhour [idate]]\n",sname);
  printf ("\n Options:\n");
  printf ("\n  -h[elp]  Print this help message. \n");
  printf ("  -g       Program uses the *current* time in GMT as the input\n");
  printf ("           date.  You CANNOT supply an idate AND use the -g option. \n");
  printf ("  -y ndig  Force the number of digits that will appear in the \n");
  printf ("           output year. ndig = 0,2 or 4, with 0 defaulting to \n");
  printf ("           the number of digits in the input year.\n");
  printf ("  fhour    Integer number of hours to add or subtract to date. \n");
  printf ("  idate    Input date.  Can be in either yymmddhh or yyyymmddhh \n");
  printf ("           format.  If no input date is specified, then the \n");
  printf ("           current system time is used.  You CANNOT supply an\n");
  printf ("           idate AND use the -g option. \n\n");
  printf ("           Please report bugs to timothy.marchok@noaa.gov\n\n");
}
