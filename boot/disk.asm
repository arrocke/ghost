; Load dh sectors to es:bx from drive dl
disk_load:
    push dx      ; Save dx so we can see if all sectors were loaded

    mov ah, 0x02 ; BIOS read sector function
    mov al, dh   ; How many sectors to read
    mov ch, 0x00 ; Cylinder 0
    mov dh, 0x00 ; Head 0
    mov cl, 0x02 ; Read from the sector after the boot sector
    int 0x13     ; BIOS disk interrupt

    jc disk_error   ; General fault (carry flag set)

    pop dx
    cmp dh, al      ; Confirm that all sectors were loaded
    jne disk_error

    ret

disk_error:
    mov ax, DISK_ERROR_MSG
    call print_string
    jmp $


DISK_ERROR_MSG:
    db 'Disk read error!',0
    
