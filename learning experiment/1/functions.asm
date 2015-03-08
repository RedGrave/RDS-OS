;	SUBROUTINES	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
print_function:
	mov ah, 0x0e
	int 0x10
	jmp returnToSomepoint
	
print_function2:
	pusha								;	All register in stack
	mov bx, 10						;	...
	add bx, 20						;	...
	mov ah, 0x0e					;	int=10 | ah=0x0e -> BIOS tele-type output
	int 0x10							;	print char in al
	popa								;	Restore original register value
	ret									;	The "ret" ensure the return to the original "call" offset.

											;	To do : Study labels page 14
											;	Studiy bios tele-type output
											
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	Other methods to defining BIOS OFFSET
; Third attempt
;mov bx , my_offset
;add bx , 0 x7c00
;mov al , [bx]
;int 0x10
