;	
;	Boot sector test to print a custom string... just for testing purpose.
;	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[org 0x7c00]						;	Tell where to load.
									;	In this case we references the bootloader reserved zone

test_1:									

mov si, HELLO_WORLD		;	store string in SI
call printstr						;	print it

call readFloppyDrive



jmp $								;	Hang

%include "string_references.asm"
%include "functions.asm"

times 510-($-$$) db 0				;	Padding rest of software
dw 0xaa55							;	Insert bootloader signature