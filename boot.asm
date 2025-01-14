[org 0x7c00]

mov bp, 0x8000          ; Initialize the stack
mov sp, bp

mov ax, start_message    ; this address is relative to the addres in the org directive
call print_string

mov dx, 0x4321
call print_hex

jmp $                   ; Infinite loop, the "os"

%include "print.asm"

start_message:
    db 'Booting OS', 0

times 510-($-$$) db 0   ; Pad 0s until the 510th byte

dw 0xaa55               ; Magic number for BIOS to detect boot sector
