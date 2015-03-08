[org 0x7c00]
KERNEL_OFFSET equ 0x1000   ; mem offset where we load our kernel

mov [BOOT_DRIVE], dl       ; BIOS stores our boot drive in DL

mov bp, 0x9000             ; set up the stack
mov sp, bp

mov bx, MSG_REAL_MODE      ; Announce that we are starting from real mode
call print_string

;call load_kernel           ; load the kernel

call switch_to_pm          ; switch to 32 bit protected mode

jmp $

%include "printString.asm"
%include "diskRead.asm"
%include "globalDescriptorTable.asm"
%include "printString_PM.asm"
%include "switchToPM.asm"

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET
	mov dh, 30 
	mov dl, [BOOT_DRIVE]
	call disk_load

	ret

[bits 32]

BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	;call KERNEL_OFFSET

	jmp $

BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode$"
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode$"
MSG_LOAD_KERNEL db "Loading kernel into memory$"

times 510 - ($ - $$) db 0
dw 0xdead