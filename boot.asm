mov ah, 0x0e            ; scrolling teletype BIOS routine

mov al, 'H'             ; character to print when invoking interrupt 0x10
int 0x10

mov al, 'e'
int 0x10

mov al, 'l'
int 0x10

mov al, 'l'
int 0x10

mov al, 'o'
int 0x10

jmp $                   ; Infinite loop, the "os"

times 510-($-$$) db 0   ; Pad 0s until the 510th byte

dw 0xaa55               ; Magic number for BIOS to detect boot sector
