[org 0x7c00]

mov ah, 0x0e            ; scrolling teletype BIOS routine

mov al, [the_secret]    ; this address is relative to the addres in the org directive
int 0x10

jmp $                   ; Infinite loop, the "os"

the_secret:
    db "X"

times 510-($-$$) db 0   ; Pad 0s until the 510th byte

dw 0xaa55               ; Magic number for BIOS to detect boot sector
