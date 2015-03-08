;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Functions BIOS
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
	
switch_to_protectedmode:
	cli
	
	lgdt		[ gdt_descriptor ]		;	Load GDT Descriptor in protectedMode
	
	mov		eax,	cr0					;	copy cr0 to eax
	or		eax,	0x1					;	set  eax firt bit to 1
	mov		cr0,	eax					;	Reassign to cr0;
	
	jmp		CODE_SEG:start_protected_mode
												; Make a far jump ( i.e. to a new segment ) to our 32- bit
												; code. This also forces the CPU to flush its cache of
												; pre - fetched and real - mode decoded instructions , which can
												; cause problems.
	
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