[org 0x7c00]
KERNEL_OFFSET equ 0x1000    ; The memory address where the kernel will be loaded

    mov [BOOT_DRIVE], dl    ; Save this so we know where to load the kernel from

    mov bp, 0x9000          ; Initialize the stack out of the way
    mov sp, bp

    mov ax, MSG_REAL_MODE
    call print_string

    call load_kernel

    call switch_to_pm       ; Enter protected mode

    jmp $                   

%include "./print.asm"
%include "./gdt.asm"
%include "./pm.asm"
%include "./disk.asm"

[bits 16]
load_kernel:
    mov ax, MSG_LOAD_KERNEL
    call print_string

    mov bx, KERNEL_OFFSET   ; Load into the kernel address
    mov dh, 15              ; Load 15 sectors to give us room for the kernel to grow
    mov dl, [BOOT_DRIVE]    ; Load from the saved boot drive
    call disk_load

    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm

    call KERNEL_OFFSET

    jmp $

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_LOAD_KERNEL db "Loaindg kernel into memory.", 0
MSG_PROT_MODE db "Successfully landed in 32 - bit Protected Mode", 0

; Boot sector detection
times 510-($-$$) db 0
dw 0xaa55

