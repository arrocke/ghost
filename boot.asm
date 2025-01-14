[org 0x7c00]

    mov bp, 0x8000          ; Initialize the stack out of the way
    mov sp, bp

    mov ax, MSG_REAL_MODE
    call print_string

    call switch_to_pm       ; Enter protected mode

    jmp $                   

%include "print.asm"
%include "gdt.asm"
%include "pm.asm"

BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm

    jmp $

MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32 - bit Protected Mode", 0

; Boot sector detection
times 510-($-$$) db 0
dw 0xaa55

