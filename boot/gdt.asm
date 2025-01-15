gdt_start:

gdt_null:       ; Mandatory null descriptor
    dd 0x00
    dd 0x00

gdt_code:
    dw 0xffff       ; Limit 0xfffff (bits 0-15)
    dw 0x0          ; Base 0x0 (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    db 10011010b    ; present - 1, previlege - 00, descriptor type - 1, type flags: code - 1, conforming - 0, readable - 1, accessed - 0
    db 11001111b    ; granularity - 1, 32-bit default - 1, 64-bit seg - 0, AVL - 0, Limit (bits 16-19) 0xf - 1111
    db 0x0          ; Base (bits 24-31)

gdt_data:
    dw 0xffff       ; Limit 0xfffff (bits 0-15)
    dw 0x0          ; Base 0x0 (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    db 10010010b    ; present - 1, previlege - 00, descriptor type - 1, type flags: data - 0, expand down - 0, writable - 1, accessed - 0
    db 11001111b    ; granularity - 1, 32-bit default - 1, 64-bit seg - 0, AVL - 0, Limit (bits 16-19) 0xf - 1111
    db 0x0          ; Base (bits 24-31)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; size of the GDT, always less one
    dd gdt_start                ; start address of the GDT

; Save constants for the offsets from the start of the GDT to each segment
; These can be loaded into the segment register to tell the CPU which segment to use when working with memory
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
