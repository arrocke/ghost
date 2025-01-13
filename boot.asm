loop:                   ; Infinite loop, the "os"
    jmp loop

times 510-($-$$) db 0   ; Pad 0s until the 510th byte

dw 0xaa55               ; Magic number for BIOS to detect boot sector
