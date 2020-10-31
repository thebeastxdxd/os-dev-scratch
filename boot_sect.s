;
; A simple boot sector program that loops forever
;

loop:        ; Define a label, "loop", that will allow
			 ; us to jump back to it, forever.

	jmp loop 

times 510-($-$$) db 0


dw 0xaa55
