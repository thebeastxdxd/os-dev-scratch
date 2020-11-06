;
; A simple boot sector program that demonstrates the stack
;
;[org 0x7c00]         ; initiate code position for address calculation

mov ah, 0x0e         ; int 10/ah = 0eh -> scrolling teletype BIOS routine

mov bp, 0x8000
mov sp, bp

;mov bx, 'A'
mov bl, 0
mov bh, 'A'

push bx
push 'B'
push 'C'

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10


mov al, [0x7ffe]
int 0x10

jmp $              ; Jump to the current address (i.e. forever).

;
; Padding and magic BIOS number.
;

times 510-($-$$) db 0
dw 0xaa55
