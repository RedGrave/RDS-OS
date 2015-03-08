[ bits 32]
; Define some constants
VIDEO_MEMORY equ 0xb8000	;	Define graphical memory address
WHITE_ON_BLACK equ 0x0f		;	Define color for text
	


start_protected_mode:
	mov ax, DATA_SEG				;Change data set to use the new 32bits protected
	mov ds, ax							;	Reset Registers' values
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, 0x90000				;	Move stack to beginning of 32bits stack space
	mov esp, ebp
	
	call BEGIN_PM						;	Begin protected mode
	
	
print_string_pm :
	pusha
	mov edx , VIDEO_MEMORY 	; Set edx to the start of vid mem.

print_string_pm_loop :
	mov al , [ ebx ] 					; Store the char at EBX in AL
	mov ah , WHITE_ON_BLACK 	; Store the attributes in AH
	cmp al , 0 							; if (al == 0), at end of string , so
	je print_string_pm_done		; jump to done
	mov [edx], ax 						; Store char and attributes at current
												; character cell.
	add ebx , 1 							; Increment EBX to the next char in string.
	add edx , 2 							; Move to next character cell in vid mem.
	jmp print_string_pm_loop 		; loop around to print the next char.

print_string_pm_done :
	popa
	ret										; Return from the function
	
BEGIN_PM :
	mov ebx , MSG_PROT_MODE	; Insert message in ebx
	call print_string_pm_loop 		; print string
	jmp BEGIN_PM						; Hang.
	
; Global references
MSG_REAL_MODE db " Started in 16- bit Real Mode ", 0
MSG_PROT_MODE db " Successfully landed in 32- bit Protected Mode ", 0