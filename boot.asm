;	
;	Boot sector test to print a custom string... just for testing purpose.
;	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[bits 16]
[org 0x7c00]						;	Tell where to load.
										;	In this case we references the bootloader reserved zone

		mov		dl, [BOOT_DRIVE]		;	
		mov		bp, 0x8000				;	Dump stack sp on 0x8000
		mov		sp, bp						;	
					
		mov		bx, 0x9000				;	Define offset 0x9000
		mov		dh, 0x04					;	Load 2 complete sector in it (512 Bytes)
		mov		dl, 0x00					;	Select boot drive
		mov		cl, 0x00						;	Start from sector 0
		call		disk_load					;
		
		mov 	bx, 0x9000					;	Define offset 0x9000
		
print_next_value:
		mov 	al, [bx]
		call		printChar
		inc		bx
		cmp		bx, 0x9004
		jl			print_next_value
		
		
		mov		bx, 0x9200				;	Define offset 0x9100
		
print_next_value2:

		mov		al, [bx]
		call		printChar
		inc		bx
		cmp		bx, 0x9204
		jl			print_next_value2

		jmp		$								;	Hang

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printstr:
	next_char:
		mov		al, [SI]							;	Before launching this, ensure that ASCII value is in AL
														;	The string reference, or offset, must be stored in SI
		inc		SI									;	Increment SI Pointer
		cmp		al, 0x00						;	Check if AL == 0
		je			exit_printstr					;	If we encounter '0', it means that we arrived at the end of the string and must end the treatement
		call		printChar						;	Print a character
		jmp		next_char						;
	exit_printstr:									;
		ret											;
		
printChar:
	mov ah, 0x0e		;	Set to write one character mode on BIOS
	int 0x10				;	Execute "PRINT"
	ret						;	return
	
disk_load:
	push dx				;	Store dx on stack
	mov ah, 0x02		;	Bios read function
	mov al, dh			;	Read dh sector
	mov ch, 0x00		;	Cylinder 0
	mov dh, 0x00		;	Head 0x00
	mov cl, 0x02			;	Start from sector 2
	int 0x13
	jc disk_error
	
	pop dx
	cmp dh, al
	jne disk_error
	ret
	
disk_error:
	mov bx, DISK_ERROR_MSG
	call printstr
	jmp $
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	String References
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HELLO_WORLD:
	db			"HELLO WORLD !!!!",0x00
	
DISK_ERROR_MSG:
	db			'Disk read error.',0x00
	
BOOT_DRIVE:
	db			0x00
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Padding File
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	times		510-($-$$) db 0x00				;	Padding rest of software
	dw			0xaa55									;	Insert bootloader signature

	times		128 db 'dead'							;	Padding data to copy, to unsure we copied good values
	times		128 db 'babe'