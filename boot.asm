;	
;	Boot sector test to print a custom string... just for testing purpose.
;	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[org 0x7c00]						;	Tell where to load.
										;	In this case we references the bootloader reserved zone
										
mov si, HELLO_WORLD		;	store string in SI
call printstr						;	print it


;mov [BOOT_DRIVE], dl		;	
mov bp, 0x8000				;	Dump stack sp on 0x8000
mov sp, bp						;	

mov bx, 0x9000				;	Define offset 0x9000
mov dh, 0x0A					;	Load 5 sector in it
mov dl, 0x00					;	Load boot drive
mov dl, 0x00

call disk_load					;

mov dx, [0x9000]	;	Read sector from our disk. sooo 512 boot sector, and then the padding we add at the end of the code [babe]
call printstr					;


jmp $								;	Hang

%include "string_references.asm"
%include "functions.asm"

times 510-($-$$) db 0				;	Padding rest of software
dw 0xaa55							;	Insert bootloader signature

times 737024 dw 0xbabe