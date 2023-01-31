;============================================================================
; hhmmss.asm
; John Schwartzman, Forte Systems, Inc.
; 01/20/2023
; linux x86_64
; yasm -f elf64 -g dwarf2 -o hhmmss.obj -l hhmmss.lst hhmmss.asm
; Useful utility for converting elapsed time in seconds into HH:MM:SS
; Build without DEF= __MAIN__ if you wish to call hhmmss from another prog
;============================ CONSTANT DEFINITIONS ==========================
LF				equ 	 10			; ASCII linefeed character
EOL   			equ 	  0			; end of line character
ZERO            equ       0         ; number 0
ONE             equ       1         ; number 1
TEN             equ      10         ; number 10
SIXTY           equ      60         ; number 60
BUFF_SIZE       equ      32

;=============================== DEFINE MACRO ===============================
%macro      zero    1
	xor     %1, %1
%endmacro
;============================================================================

section		.text					;============= CODE SECTION =============

%ifndef __MAIN__                    ;========== BUILD WITHOUT MAIN ==========

global      toHHMMSS                ; tell linker about export

%else                               ;=========== BUILD WITH MAIN ============

global      main                    ; tell linker about exports
extern      printf, scanf           ; tell assembler/linker about externals

;============================== MAIN FUNCTION ===============================
main:
	push    rbp
	mov     rbp, rsp

	lea     rdi, [promptFormat]     ; 1st arg to printf
	zero    rax
	call    printf                  ; prompt user

	lea     rdi, [scanfFormat]      ; 1st arg to scanf
	lea     rsi, [x]                ; 2nd arg to scanf
	zero    rax
	call    scanf                   ; get x

	mov     rdi, [x]                ; x is the long we want in hh:mm:ss fmt
	call    toHHMMSS                ; return pointer to outputBuf in rax
    mov     rdi, rax                ; get char array returned by toHHMMSS
	zero    rax                     ; no floating point args
	call    printf
	lea     rdi, [outputFormat]
	zero    rax
	call    printf                  ; write 2 line feeds

	leave
	ret

%endif  ;==================== BUILD WITHOUT MAIN ============================     

;============================= EXPORTED FUNCTION ============================
toHHMMSS:                           ; param rdi = long int
	push    rbp
	mov     rbp, rsp

	lea     rsi, [outputBuf]        ; rsi => destination buffer

	mov     rax, rdi                ; rdi = param
	zero    rdx
	mov     rcx, SIXTY * SIXTY
	div     rcx                     ; rax = num hours

	push    rdx						; save remainder = num min + num seconds
	mov		rdi, rax
	call    writeTwoDigits			; write num hours
	call    writeColon
	pop     rax						; restore remainder

	mov		rcx, SIXTY
	zero	rdx
	div		rcx						; rax = num minutes

	push	rdx						; save remainder = num seconds
	mov		rdi, rax
	call 	writeTwoDigits			; write num minutes
	call	writeColon

	pop		rdi						; restore remainder

	call	writeTwoDigits			; write num seconds

	lea    rax, [outputBuf]        ; return pointer to outputBuf in rax

	leave
	ret

;============================= LOCAL FUNCTION ===============================
writeTwoDigits:                     ; param:  rdi = int 0 through 99
	push    rbp
	mov     rbp, rsp

	mov     rax, rdi                ; rax = dividend
	zero    rdx
	mov     rcx, TEN                ; tens
	div     rcx                     ; rax = number of tens
	call    writeDigit				; writes the byte in al

	mov     rax, rdx                ; rax = remainder = number of ones
	call    writeDigit				; writes the byte in al

	leave
    ret

;============================= LOCAL FUNCTION ===============================
writeDigit:                         ; no parameter; rax = 0-9
	add     al, '0'                 ; convert to char
	mov     [rsi], al               ; write char
	inc     rsi                     ; increment write pointer
	ret

;============================= LOCAL FUNCTION ===============================
writeColon:							; no parameter							
	mov     al, ':'
	mov     [rsi], al
	inc     rsi
	ret

;==============================  DATA SECTION ===============================
section     .data
x           dq      0

;========================== UNINITIALIZED DATA SECTION ======================
section		.bss
outputBuf	resb	BUFF_SIZE

;========================= READ-ONLY DATA SECTION ===========================
section 	.rodata	
scanfFormat	    db		"%ld", EOL
promptFormat    db      "Enter an integer: ", EOL
outputFormat    db      LF, LF, EOL
;============================================================================
