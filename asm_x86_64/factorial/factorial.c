// factorial.c
// John Schwartzman, Forte Systems, Inc.
// 01/25/2023
// x86_64

#define ZERO    0
#define ONE     1
#define MAX_INT 20

#if defined(__COMMA__)

    char* commaSeparate(long n);     // declaration of asm function

#endif //__COMMA__ 

#include<stdio.h>   // for printf and scanf

// recursive function to compute factorial of n
long factorial(int n)
{
    if (n == ZERO) // base case
    {
        return ONE;
    }
    else
    {
        return (n * factorial(n - ONE));
    } 
}  
    
int main()  
{  
    int     n;  
    long    fact;

    do  {
            printf("\nEnter a positive integer less than or equal to %d: ", MAX_INT);  
            scanf("%d", &n); 
        }
    while (n < ZERO || n > MAX_INT);
    
    fact = factorial(n);  
    printf("%d! = %ld\n", n, fact);
  
#if defined(__COMMA__)
    char* pBuffer = commaSeparate(fact);  
    printf("%d! = %s\n\n", n, pBuffer);
#endif  //__COMMA__

    return 0;  
}  