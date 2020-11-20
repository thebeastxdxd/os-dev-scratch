; load DH sectors to ES:BX from drive DL
disk_load:
	push dx              ; Store DX on stack so later we can recall
						 ; how many sectors we request to be read,
						 ; even if it is altered in the meantime
	mov ah, 0x02         ; BIOS read sector function
	mov al, dh           ; Read DH sectors
	mov ch, 0x00         ; Select cylinder 0
	mov dh, 0x00         ; Select head 0 
	mov cl, 0x02         ; Start reading from second sector (after boot sector)

	int 0x13             ; Issue the BIOS interrupt to do the actual read.

	jc disk_error        ; jump if carry flag is set.

	pop dx
	cmp dh, al           ; if AL (sectors read) != DH (sectors expected)
	jne disk_error       ; display error message
	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $

DISK_ERROR_MSG:
	db "Disk read error!\n", 0

