[bits 16]
switch_to_pm:
    cli                     ; Disable interrupts util we have set them up again in protected mode

    lgdt [gdt_descriptor]    ; Load GDT address

    mov eax, cr0            ; Enable protected mode by setting the first bit of the control register
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm    ; Do a far jump to clear the CPU pipeline so new instructions are operating in the right mode

[bits 32]
init_pm:
    mov ax, DATA_SEG        ; Point all segment registers to the data segment descriptor
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; Reinitalize the stack to the edge of free space
    mov esp, ebp

    call BEGIN_PM           ; call protected mode

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print_string_pm:
    pusha

    mov edx, VIDEO_MEMORY  ; Start printing at the top left corner

; This loop executes for each character starting at the address in ebx until a null
print_string_pm_loop_start:
    mov al, [ebx]
    mov ah, WHITE_ON_BLACK

    ; If the value at the address bx is null, we are done, jump to the end
    cmp al, 0
    je print_string_pm_loop_end

    ; Send the char and attributes to video memory
    mov [edx], ax

    ; Go to the next character in the string and video memory and loop again
    add edx, 2
    add ebx, 1
    jmp print_string_pm_loop_start

print_string_pm_loop_end:
    popa
    ret

