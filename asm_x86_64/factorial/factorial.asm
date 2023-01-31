;============================================================================
; factorial.asm
; John Schwartzman, Forte Systems, Inc.
; 12/26/2022
; Linux x86_64
; yasm -f elf64 -g dwarf2 -o factorial.obj -l factorial.lst factorial.asm
;============================ CONSTANT DEFINITIONS ==========================
LF				equ 	 10			; ASCII linefeed character
EOL   			equ 	  0			; end of line character
ONE             equ       1         ; number 1
VAR_SIZE		equ 	  8			; each local var is 8 bytes
NUM_VAR			equ		  2			; number local var (round up to even num)
MAX_INPUT       equ      20         ; max size input
EXIT_SUCCESS	equ  	  0			; return 0 to indicate success
EXIT_FAILURE    equ      -1         ; return -1 to indicate failure

;=============================== DEFINE MACRO ===============================
%macro      zero    1
    xor     %1, %1
%endmacro

;========================== DEFINE LOCAL VARIABLES ==========================
%define		buffer	qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0

;============================== CODE SECTION ================================
section		.text					;============= CODE SECTION =============
global 		main                    ; tell linker about export
extern 		scanf, printf        	; tell assembler/linker about externals

%ifdef __COMMA__                    ;========== use commaSeparate ===========
    extern      commaSeparate
%endif                              ;========================================

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, NUM_VAR*VAR_SIZE   ; make space on stack for buffer variable

    lea     rdi, [promptFmt]        ; 1st arg to printf
    zero    rax
    call    printf                  ; prompt user

    lea     rdi, [scanfFmt]         ; 1st arg to scanf
    lea     rsi, [x]                ; 2nd arg to scanf
    zero    rax
    call    scanf                   ; get x
    mov     rax, [x]
    cmp     rax, MAX_INPUT
    jg      badInput
    or      rax, rax
    jnz     continue

badInput:
    lea     rdi, [wrongInputStr]
    zero    rax
    call    printf
    mov     rax, EXIT_FAILURE
    jmp     fin

continue:
    mov     rdi, [x]                ; save x
    call    factorial
    mov     [fact], rax             ; save factorial of x

%ifndef __COMMA__                   ;========== BUILD STANDALONE ============

    lea     rdi, [outputFmt]        ; 1st arg to printf
    mov     rsi, [x]                ; 2nd arg to printf
    mov     rdx, fact               ; 3rd arg to printf
    zero    rax
    call    printf                  ; print result

%else                               ; == DISPLAY RESULT with commaSeparate ==

    mov     rdi, rax                ; 1st and only arg to commaSeparate
    call    commaSeparate
    mov     buffer, rax             ; save commaSeparate's output buffer

    lea     rdi, [outputFmtCommma]  ; 1st arg to printf
    mov     rsi, [x]                ; 2nd arg to printf
    mov     rdx, buffer             ; 3rd arg to printf
    zero    rax
    call    printf                  ; print "x! = "

;    mov     rdi, buffer             ; restore commaSeparate's output buffer
;    zero    rax
;    call    printf                  ; and print it

    lea     rdi, [outputLF]
    zero    rax
    call    printf                  ; print 2 linefeeds

%endif                              ; == DISPLAY RESULT with commaSeparate ==

    zero    rax                     ; return EXIT_SUCCESS

fin:
    add     rsp, NUM_VAR*VAR_SIZE   ; remove space for buffer
    leave
    ret

;============================= EXPORTED FUNCTION ============================

;========================== DEFINE LOCAL VARIABLE ===========================
%define		n	    qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0

;============================== CODE SECTION ================================
factorial:
    push    rbp
    mov     rbp, rsp
    sub     rsp, NUM_VAR*VAR_SIZE   ; make space for n

    cmp     rdi, ONE                ; base case?
    jg      greater                 ;    jump if no
    mov     rax, ONE                ; the answer to the base case

    add     rsp, NUM_VAR*VAR_SIZE   ; remove local variable n
    leave
    ret

greater:
    mov     n, rdi                  ; save n
    dec     rdi                     ; call factorial with n - 1
    call    factorial               ; recursive call to factorial

    mov     rdi, n                  ; restore original n
    imul    rax, rdi                ; multiply factorial(n - 1) * n

    leave
    ret

;==============================  DATA SECTION ===============================
section     .data
x               dq      0           ; number for which we want factorial
fact            dq      0           ; factorial of x86_64

;========================= READ-ONLY DATA SECTION ===========================
section 	.rodata	
scanfFmt	    db		"%ld", EOL
promptFmt       db      LF, "Enter an integer from 1 to 20: ", EOL
outputFmt	    db		"%d! = %ld", LF, EOL
outputFmtCommma db      "%d! = %s", LF, EOL
wrongInputStr   db      "You have entered an invalid number.", LF, LF, EOL
outputLF        db      LF, LF, EOL
;============================================================================
