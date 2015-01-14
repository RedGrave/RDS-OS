;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	String References
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print:
    next_character:
        mov al, [si]
        inc si
        or al, al
        jz exit_function
        call PrintCharacter
        jmp next_character
    exit_function:
        ret
		
PrintCharacter:
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    ret
