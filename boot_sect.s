;
; A simple boot sector program that demonstrates the stack
;
[org 0x7c00]         ; initiate code position for address calculation
mov bp, 0x8500
mov sp, bp 

mov bx, HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string
mov dx, 0x1fb6
call print_hex

jmp $              ; Jump to the current address (i.e. forever).

%include "print_string.asm"

;Data
HELLO_MSG:
	db "Hello, World!", 0 
GOODBYE_MSG:
	db "Goodbye!", 0

;
; Padding and magic BIOS number.
;

times 510-($-$$) db 0
dw 0xaa55
