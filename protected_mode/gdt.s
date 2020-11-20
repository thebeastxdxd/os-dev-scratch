; Transfering to protected mode requires us to define a GDT.
; Nn 16 bit mode we calculate an address by multiplying our segment register by 16
; then adding our offset. 
; Now (in protected mode) our segment register becomes an index to a particular segment descriptor
; in the GDT.
; The Segment Descriptor (SD) is an 8-byte structure that defines the following properties of
; a protected-mode segment.
; Base address (32 bits), which defines where the segment begins in physical memory
; Segment Limit (20 bits), which define the size of the segment
; Various flags, which affect how the CPU interprets the segment, such as the privilige
; level of code that runs within it or whether it is read- or write -only.
;
; A simple workable configuration of segment registers is described by Intel as the
; basic flat model, whereby two overlapping segments are defined that cover the full 4 GB
; of addressable memory, one for code and the other for data. 
; The fact that in this model these two segments overlap means that there is no attempt to protect
; one segment from the other nor is there any attempt to use the paging feature for virtual memory.
; The first entry of the GDT is required to be a null descriptor.
; the null descriptor is a simple mechanism to ctach mistakes where we forget to set a
; particular segment register before accessing an address.


; GDT
gdt_start:

gdt_null:  ; the mandatory null descriptor
	dd 0x0 ; 'dd' means define double word (i.e. 4 bytes)
	dd 0x0 

gdt_code:  ; the code segment descriptor
	; base=0x0 limit=0xfffff,
	; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
	; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
	; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
	dw 0xffff      ; Limit (bits 0-15)
	dw 0x0         ; Base (bits 0-15)
	db 0x0         ; Base (bits 16-23)
	db 10011010b   ; 1st flags, type flags
	db 11001111b   ; 2nd flags, Limit (bits 16-19)
	db 0x0         ; Base (bits 24-31)

gdt_data:  ; the data segment descriptor
    ; Same as code segment except for the type flags:
	; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
	dw 0xffff      ; Limit (bits 0-15)
	dw 0x0         ; Base (bits 0-15)
	db 0x0         ; Base (bits 16-23)
	db 10010010b   ; 1st flags, type flags
	db 11001111b   ; 2nd flags, Limit (bits 16-19)
	db 0x0         ; Base (bits 24-31)

gdt_end:       ; The reason for putting a label at the end of the 
			   ; GDT is so we can have the assembler calculate
			   ; the size of the GDT for GDT descriptor (below)

; GDT descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1   ; Size of our GDT, alway less one
	                             ; of the true size
	dd gdt_start                 ; Start address or our GDT

; Define some handy constants for the GDT segment descriptor offsets, which
; are what segment registers must contain when in protected mode. For example,
; when we set DS = 0x10 in PM, the CPU knows taht we mean it to use the
; segment described in offset 0x10 (i.e. 16 bytes) in our GDT, which in out case
; is the DATA segment (0x0 -> NULL; 0x08 -> code; 0x10 -> DATA)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
