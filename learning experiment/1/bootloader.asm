;
;	My first bootloader, really simple
;

	;	Observation
	;	
	;	1.	The BootLoader section in memory start at 0x7c00
	;		Which means we can precalculate memory offset to retrieve
	;		values. So, we can start using 0x7c1e to write data
	;
	;		-exemple:	
	;			mov al, [myLabel]
	;			int	0x10
	;
	;			myLabel:
	;				db "label",0
	;
	;	2.	Here are come commands:
	;		-exemple:
	;			je jne					Jump equal, Jump not equal
	;			jl jle jg jge				Jump less, less or equal, greater, greater or equal
	;			cmp						Compare

	

;	STRINGS AND REFERENCES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	%include "stringsReferences.asm"		;	Include asm file here. The %include will be overwritten by contempt of file
	%include "functions.asm"					

mov al, [0x7c1e]
int 0x10

mov bp, [0x8000]				;	Create/move stack at 0x8000
mov sp, bp						;	Copy stack from bp to sp to prevent overwriting

push 'A'							;	Exemple of pushing ASCII standard value into stack
push 'R'							;
push 'P'							;	WARNING : Data are only pushed in 16-bits real mode

pop bx								;	Exemple of popping value from stack
										;	WARNING : Data are only popped in 16-bits real mode.
										
mov al, [0x7ffe]					;	The stack goes from 0x8000 to 0x7e00;
										;	It grows from biggest to lowest offset. Here is the first value we inserted;
mov al, [0x7ffc]					;	And here is the second value;

cmp al, 4							;	Compare instruction.
je HelloWorld					;	If condition is met, move to HelloWorld.
	
jmp HelloWorld					;	Jump to HelloWorld Address, which will then jmp in current address....

mov al, 'H'
jmp print_function				;	jmp to subroutine
returnToSomepoint:			;	Ensure that we can get back after subroutine... quick 'n' dirty exemple

mov al, 'H'
call print_function2				;	call a subroutine



jmp $								;	Jump to current instruction offset
	
	
	
times	510-($-$$)	db 0x00		;	Must have 510 bits + 2 bits specified.
								;	So we: db 0 : Define value to current address = 0
								;	510 times
								;	And then write 0x55aa (IN BIG ENDIAN !! We'll write in little endian in this code)
	
	dw	0xaa55					;	Here we're adding the magic number