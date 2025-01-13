mov ah, 0x0e            ; scrolling teletype BIOS routine

mov al, the_secret      ; this won't work because `the_secret` is an offset, not the contents of the offset
int 0x10

mov al, [the_secret]    ; this will print the contents of the address, but still won't work because
int 0x10                ; the offset is treated here as from the beginning of memory rather than from where the boot sector is in memory

mov bx, the_secret      ; this works because we have added the offset to the memory location of the boot sector
add bx, 0x7c00          ; before we read the contents of the address
mov al, [bx]
int 0x10

mov al, [0x7c1d]        ; this also works because we precomputed the calculation
int 0x10

jmp $                   ; Infinite loop, the "os"

the_secret:
    db "X"

times 510-($-$$) db 0   ; Pad 0s until the 510th byte

dw 0xaa55               ; Magic number for BIOS to detect boot sector
