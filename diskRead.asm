;load DH sectors to ES:BX from drive DL

disk_load:
	push dx ;push dx on stack so later we can recall how many sectors we wanted
	
	mov ah, 0x02 ; BIOS read-disk function
	mov al, dh
	mov ch, 0x00 ; cylynder 0
	mov dh, 0x00 ; head 0
	mov cl, 0x02 ; start reading second sector
	
	int 0x13     ; BIOS interrupt
	
	jc disk_error ; if carry flag is set there was an error
	
	pop dx        ; restore dx so we can remember how many sectors we wanted
	cmp dh, al    ; number of sectors read is returned in al, so compare what 
	              ; we wanted to what we actually read
	jne disk_error
	ret
	
disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $
	
DISK_ERROR_MSG db "Disk read error", $