;============================================================================
; commaSeparate.asm
; John Schwartzman, Forte Systems, Inc.
; 01/25/2023
; Linux x86_64
;
;============================ CONSTANT DEFINITIONS ==========================
LF				equ 	 10			; ASCII linefeed character
EOL   			equ 	  0			; end of line character
VAR_SIZE        equ       8         ; number of bytes in a variable
NUM_VAR			equ		  2			; number local var (round up to even num)
BUFF_SIZE       equ      32
TEN             equ      10                     
HUNDRED         equ     100
THOUSAND        equ    1000
MILLION         equ    THOUSAND * THOUSAND
BILLION         equ    THOUSAND * MILLION
TRILLION        equ    THOUSAND * BILLION
QUADRILLION     equ    THOUSAND * TRILLION
QUINTILLION     equ    THOUSAND * QUADRILLION

; NOTE: SEXTILLION equ THOUSAND * QUINTILLION doesn't fit in a 64 bit field

;=============================== DEFINE MACRO ===============================
%macro      zero    1
    xor     %1, %1
%endmacro

;=============================== DEFINE MACRO ===============================
%macro prologue	0					;=== prologue macro takes 0 arguments ===
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack now aligned
%endmacro

;=============================== DEFINE MACRO ===============================
%macro epilogue 0
	leave
	ret
%endmacro

;=============================== DEFINE MACRO ===============================
%macro  writePowerOfTenToThird  1   ; power is the divisor
    zero    rdx
    mov     rax, n                  ; get n; n (rdx:rax) is the dividend
    mov     rcx, %1                 ; %1 = power  
    div     rcx                     ; rax = power / n, rdx = remainder
    mov     rdi, rax                ; rax = quotient
    mov     n, rdx                  ; save remainder (what's left of n)
    call    writeThreeDigits        ; write quotient
    call    writeComma              ; write comma if bFound != ZERO
%endmacro

;=============================== DEFINE MACRO ===============================
%macro  writeUnits  0
    mov     rdi, n                  ; get what's left of n
    call    writeThreeDigits
%endmacro

;========================== DEFINE LOCAL VARIABLES ==========================
%define		n 		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0

;============================== CODE SECTION ================================
section		.text					;============= CODE SECTION =============

%ifndef __MAIN__                    ;========== BUILD WITHOUT MAIN ==========

global      commaSeparate           ; tell linker about exports

%else                               ;=========== BUILD WITH MAIN ============

global      main                    ; tell linker about exports
extern      printf, scanf           ; tell assembler/linker about externals

;============================== MAIN FUNCTION ===============================
main:
    prologue

    lea     rdi, [promptFormat]     ; 1st arg to printf
    zero    rax
    call    printf                  ; prompt user

    lea     rdi, [scanfFormat]      ; 1st arg to scanf
    lea     rsi, [x]                ; 2nd arg to scanf
    zero    rax
    call    scanf                   ; get x

    mov     rdi, [x]                ; x is the long we want to separate
    call    commaSeparate           ; return pointer to outputBuf in rax
    mov     rdi, rax                ; 1st and only arg to printf
    zero    rax                     ; no floating point args
    call    printf

    lea     rdi, [outputFormat]
    zero    rax
    call    printf                  ; write 2 line feeds
    
    zero    rax                     ; return 0 for success

	epilogue

%endif  ;====================== BUILD WITH MAIN =============================     

;============================= EXPORTED FUNCTION ============================
commaSeparate:                      ; param rdi = long int
	prologue
    sub     rsp, NUM_VAR * VAR_SIZE ; make space for n
    push    r12                     ; save r12 - we use it as bFound variable

    lea     rsi, [outputBuf]        ; rsi => destination buffer
    mov     n, rdi                  ; get/save parameter (n)

    or      rdi, rdi                ; n == 0 ?
    jnz     .continue               ;   no
    call    writeZero               ; special case to write n = 0
    jmp     fin

.continue:
    writePowerOfTenToThird QUINTILLION  ; n / 1 QUINTILLION
    writePowerOfTenToThird QUADRILLION  ; n / 1 QUADRILLION
    writePowerOfTenToThird TRILLION     ; n / 1 TRILLION
    writePowerOfTenToThird BILLION      ; n / 1 BILLION
    writePowerOfTenToThird MILLION      ; n / 1 MILLION
    writePowerOfTenToThird THOUSAND     ; n / 1000
    writeUnits                          ; n / 1

fin:
    lea     rax, [outputBuf]        ; return pointer to outputBuf in rax

    pop     r12                     ; restore r12
    add     rsp, NUM_VAR * VAR_SIZE ; remove space for n and bFound
    epilogue

;============================= LOCAL FUNCTION ===============================
writeThreeDigits:                   ; parameter: rdi = any int from 0 to 999
    prologue

    mov     rax, rdi
    zero    rdx                
    mov     rcx, HUNDRED
    div     rcx                     ; rax = number of hundreds
    call    writeNTmp               ; write hundreds

    mov     rax, rdx                ; process remainder (tens and ones)
    zero    rdx
    mov     rcx, TEN
    div     rcx                     ; rax = number of tens
    call    writeNTmp               ; write tens

    mov     rax, rdx                ; rax = number of ones
    call    writeNTmp               ; write ones

    epilogue

;=========================== LOCAL LEAF FUNCTION ===============================
writeComma:                         ; no arguments
    or      r12, r12                ; bFound == 0 ?
    jz      .noWrite                ;   jump if yes
    mov     al, ','
    mov     [rsi], al               ; write comma into output buffer
    inc     rsi

.noWrite:
    ret

;============================== LOCAL LEAF FUNCTION ===========================
writeNTmp:                          ; rax = (0-9), rsi => outputBuf
    or      al, al                  ; al == 0 ?
    jnz     .continue               ; jump if no
    or      r12, r12                ; bFound ?
    jz     .fin                     ; don't write a '0' if !bFound
    
.continue:
    inc     r12                     ; bFound = true
    add     al, '0'                 ; convert to char
    mov     [rsi], al               ; write char
    inc     rsi                     ; increment write pointer

.fin:
    ret

;=========================== LOCAL LEAF FUNCTION ============================
writeZero:                          ; rax = n (0)
    add     al, '0'                 ; convert to char
    mov     [rsi], al               ; write char
	inc		rsi						; write EOF
	xor		al, al
	mov		[rsi], al
    ret

;==============================  DATA SECTION ===============================
section     .data
x           dq      2432902008176640000

;========================== UNINITIALIZED DATA SECTION ======================
section		.bss
outputBuf	resb	BUFF_SIZE

;========================= READ-ONLY DATA SECTION ===========================
section 	.rodata	
scanfFormat	    db		"%ld", EOL
promptFormat    db      "Enter a positive long integer: ", EOL
outputFormat    db      LF, LF, EOL
;============================================================================
