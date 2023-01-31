// commaSeparate.c
// John Schwartzman, Forte Systems, Inc.
// 01/23/2023
// x86_64

#include <stdio.h>

#define ZERO    0
#define ONE     1

char* commaSeparate(long n);     // declaration of asm function

int main()  
{  
	long     n;  

	printf("\nEnter a positive long integer: ");  
	scanf("%ld", &n); 
	
	char* pBuffer = commaSeparate(n);  
	printf("Output of commaSeparate(%ld): %s\n\n", n, pBuffer);
 
	return 0;  
}  