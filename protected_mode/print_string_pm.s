[bits 32]
; Define some constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f


; Prints a null-terminated string pointed to by EBX
; This routine always prints to the start of vid mem, effectivly 
; overwriting previous messages.
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY

print_string_pm_loop:
	mov al, [ebx]           ; Store the char at EBX in AL
	mov ah, WHITE_ON_BLACK  ; Store the attributes in AH

	cmp al, 0               ; Check for Null byte (for end of string)
	je print_string_pm_done

	mov [edx], ax

	add ebx, 1              ; go to next char
	add edx, 2              ; go to next character cell in vid mem

	jmp print_string_pm_loop    ; loop around to print the next char.

print_string_pm_done:
	popa
	ret 
