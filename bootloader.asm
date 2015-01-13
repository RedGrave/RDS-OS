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

;	SUBROUTINES	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bootstring:
	db 'Booting in progress...',0	;	The ",0" is called a null terminating
									;	It forces the string to end with a null character
									;	So we can know when the string ends
	
HelloWorld:
	db 'Hello World',0

											;	Define HelloWorld so we can loop through it forever
											;	To do : Study labels page 14
											
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	Other methods to defining BIOS OFFSET
; Third attempt
;mov bx , the_secret
;add bx , 0 x7c00
;mov al , [bx]
;int 0x10

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
jmp $								;	Jump to current instruction offset
	
	
	
times	510-($-$$)	db 0x00		;	Must have 510 bits + 2 bits specified.
								;	So we: db 0 : Define value to current address = 0
								;	510 times
								;	And then write 0x55aa (IN BIG ENDIAN !! We'll write in little endian in this code)
	
	dw	0xaa55					;	Here we're adding the magic number