;
; A simple boot sector program that demonstrates the stack
;
;[org 0x7c00]         ; initiate code position for address calculation

mov bx, 30

a_label:
	cmp bx, 4
	jg b_label
	mov al, 'A'
	jmp print
b_label:
	cmp bx, 40
	jge c_label
	mov al, 'B'
	jmp print
c_label:
	mov al, 'C'

print:
	mov ah, 0x0e         ; int 10/ah = 0eh -> scrolling teletype BIOS routine
	int 0x10

jmp $              ; Jump to the current address (i.e. forever).

;
; Padding and magic BIOS number.
;

times 510-($-$$) db 0
dw 0xaa55
