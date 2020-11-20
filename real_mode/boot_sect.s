;
; A simple boot sector program that demonstrates the BIOS read disk function
;
[org 0x7c00]         ; initiate code position for address calculation

mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL, so it's 
                     ; best to remember this for later

mov bp, 0x8000       ; Here we set our stack safely out of the
mov sp, bp           ; way, at 0x8000


;mov bx, HELLO_MSG
;call print_string

mov bx, 0x0000
mov es, bx
mov bx, 0x9000       ; Load 5 sectors to 0x0000(ES):0x9000(BX)
mov dh, 2            ; from the boot disk
mov dl, [BOOT_DRIVE]
call disk_load

mov dx, [0x9000]     ; Print out the first loaded word, which
call print_hex       ; we expect to be 0xdada, stored at address 0x9000

mov dx, [0x9000 + 512] ; Also, print the first word from the 2nd loaded
call print_hex         ; sector: should be 0xface

mov bx, GOODBYE_MSG
call print_string

jmp $              ; Jump to the current address (i.e. forever).

%include "print_string.asm"
%include "disk_read.asm"

;Data
BOOT_DRIVE:
	db 0
HELLO_MSG:
	db "Hello, World!\n", 0 
GOODBYE_MSG:
	db "Goodbye!\n", 0

;
; Padding and magic BIOS number.
;

times 510-($-$$) db 0
dw 0xaa55

; We know that BIOS will load only the first 512-byte sector from the disk,
; so if we purposely add a few more sectors to our code by tepeating some
; familiar numbers, we can prove to ourselves that we actually loaded those
; additional two sectors from teh disk we booted from.
times 256 dw 0xdada ; second sector
times 256 dw 0xface ; thirst sector
