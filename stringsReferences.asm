;;;;;;;;;;

bootstring:
	db 'Booting in progress...',0	;	The ",0" is called a null terminating
									;	It forces the string to end with a null character
									;	So we can know when the string ends
	
HelloWorld:
	db 'Hello World',0
	
;;;;;;;;;;