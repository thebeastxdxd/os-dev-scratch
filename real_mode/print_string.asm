

print_string:
	; parameter in bx
	pusha
	mov ah, 0x0e
loop:
	mov al, [bx]	
	cmp al, 0
	je exit

	int 0x10

	inc bx
	jmp loop
exit:
	popa
	ret


print_hex:
	; parameter in dx
	pusha
	; cant use cx for effective address calc in 16-bit, so using di instead
	; loop 4 times (o based) for 16 bit reg
	mov di, 3
	mov bx, HEX_OUT
hex_loop:
	mov ax, dx
	and ax, 1111b
	cmp al, 10
	jge greater_10
	add al, '0'
	jmp add_char

greater_10:
	sub al, 10
	add al, 'A'

add_char:
	
	; add 2 for prefix
	mov [bx + di + 2], al	
	shr dx, 4
	dec di
	cmp di, 0
	jnz hex_loop
	
hex_exit:
	call print_string
	popa
	ret

HEX_OUT:
	db '0x0000', 0
