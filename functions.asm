;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printstr:
	next_char:
		mov al, [SI]							;	Before launching this, ensure that ASCII value is in AL
													;	The string reference, or offset, must be stored in SI
		inc SI									;	Increment SI Pointer
		or AL, AL								;	Check if AL == 0
		jz exit_printstr						;	If we encounter '0', it means that we arrived at the end of the string and must end the treatement
		call printChar						;	Print a character
		jmp next_char						;
	exit_printstr:								;
		ret										;
		
printChar:
	mov ah, 0x0e		;	Set to write one character mode on BIOS
	mov bh, 0x00		;	Set page N°
	mov bl, 0x0A		;	Set color to green on black
	
	int 0x10				;	Execute "PRINT"
	ret						;	return
	
readFloppyDrive:
	mov ah, 0x02		;	Set Bios to READ DISK
	mov dl,0x00			;	Set DISK to 0
	mov ch, 0x03		;	Select Cylinder 3
	mov dh, 0x00		;	Read recto of floppy. Verso is 0x01
	mov cl, 0x04			;	Select the fourth sector
	mov al, 0x05		;	Read 5 sectors from the start point
	
								;	Once parametrized, let's read it to some point
								;	We must specify an address to store data
	
	mov bx, 0xa000	;	Set segment ES to 0xa000
	mov es, bx			;	Prepare first address of segment
	mov bx, 0x1234	;	Set endpoint to 0x1234
	
								;	This means we're going to read 5 sectors and store them from 0xa000 to 0x1234
								
	int 0x13				;	Interrupt
	jc disk_error			;	Jump if carry flag is set.
	
	cmp al, 0x05			;	If we didn't read n° of sector expected
	jne disk_error

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
	
print_hex:
	mov bx, HEX_OUT
	call printstr
	ret
	
	
disk_error:
	mov bx, DISK_ERROR_MSG
	call printstr
	jmp $