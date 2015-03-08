
mov ah, 0x0e

print_string:	
	pusha
	mov ah, 0x0e
	
	loop:
		mov al, [bx]
		cmp al, '$' 
		je return
		int 0x10
		inc bx
		jmp loop
		
	return:
		popa 
		ret