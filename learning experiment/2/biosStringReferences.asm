;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	String References
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HELLO_WORLD:
	db			"HELLO WORLD !!!!",0x00
	
DISK_ERROR_MSG:
	db			'Disk read error.',0x00
	
BOOT_DRIVE:
	db			0x00