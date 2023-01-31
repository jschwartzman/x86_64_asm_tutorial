// environment.c
// John Schwartzman, Forte Systems, Inc.
// 01/21/2023

#include <time.h>       // declaration of time; definition of time_t

int printenv(const char* timestr);   // declaration of asm function

int main(void)
{
    time_t  now;
    char*   strTime;

    time(&now);
    strTime = ctime(&now);
    return printenv(strTime);       // call printenv function with strTime arg
}
   