;	
;	Boot sector test to print a custom string... just for testing purpose.
;	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[bits 16]
[org 0x7c00]						;	Tell where to load.
										;	In this case we references the bootloader reserved zone

		mov		bp, 0x9000				;	Dump stack sp on 0x9000
		mov		sp, bp						;	
					
		mov 	bx, HELLO_WORLD	;
		
		call		printstr
													;	this is definitive
		call		switch_to_protectedmode
loop2:
		mov ah, 0x0e		;	Set to write one character mode on BIOS
		mov al, 0x24
		int 0x10				;	Execute "PRINT"
		jmp		loop2
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Bios 16bits Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	%include "biosFunction.asm"
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Bios String references
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	%include "biosStringReferences.asm"
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Global Description Table Definition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	%include "globalDescriptor.asm"
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	PROTECTED MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	%include "protectedMode.asm"
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Padding File
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	times		510-($-$$) db 0x00				;	Padding rest of software
	dw			0xaa55									;	Insert bootloader signature

	times		128 db 'dead'							;	Padding data to copy, to unsure we copied good values
	times		128 db 'babe'