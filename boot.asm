;	
;	Boot sector test to print a custom string... just for testing purpose.
;	
%include "string_references.asm"
%include "functions.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[org 0x7c00]						;	Tell where to load.
									;	In this case we references the bootloader reserved zone

test_1:									
	mov bx, HELLO_WORLD				;	use bx as parameter
	call print							;	call the print functions

	mov bx, SHUTDOWN					;	use bx as parameter
	call print							;	call the print function again
	
	jmp test_1

jmp $								;	Hang

times 510-($-$$) db 0				;	Padding rest of software
dw 0xaa55							;	Insert bootloader signature