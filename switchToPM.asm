[bits 16]

; Switch to protected mode
switch_to_pm:

	cli                      ; disable interrupts until we set up the protected mode's
					         ; own interrupt vector if not we might crash if an
					         ; interrupt is called
	
	lgdt [gdt_descriptor]    ; load the gdt defining the protected mode segments
	
	mov eax, cr0             ; to switch to protected mode we set the first bit of
	or eax, 0x1              ; a control register named cr0
	mov cr0, eax
	
	jmp CODE_SEG:init_pm     ; far jump to our 32 bit code, forcing the cache
							 ; of prefetched instructions to finish executing
							 
[bits 32]

;initialize the segment registers and the stack based on newly loaded GDT
init_pm:
	
	; our old segments are useless so we point them all to our GDT data segment
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	;update our stack position to the top of the free space
	mov ebp, 0x90000
	mov esp, ebp
	
	call BEGIN_PM            ; we're done start using protected mode
	