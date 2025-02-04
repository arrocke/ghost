; Prints null terminated string at the address stored in al
print_string:
    pusha
    ; We want to use the BIOS 0x10 interrupt to print the contents of ax, so we use bx as the address counter
    mov bx, ax  
    ; Set up the scrolling teletype BIOS routine
    mov ah, 0x0e

; This loop executes for each character starting at the address in bx until a null
print_string_loop_start:
    mov al, [bx]
    ; If the value at the address bx is null, we are done, jump to the end
    cmp al, 0
    je print_string_loop_end
    ; Otherwise, print the character
    int 0x10
    ; Go to the next character and loop again
    add bx, 1
    jmp print_string_loop_start

print_string_loop_end:
    popa
    ret

; Prints the value in dx in hex.
print_hex:
    pusha

    mov cx, dx
    and cx, 0x0f        ; Isolate lowest half-byte
    call calc_hex_digit
    mov [HEX_OUT+5], cl

    shr dx, 4           ; Shift over a half-byte
    mov cx, dx
    and cx, 0x0f
    call calc_hex_digit
    mov [HEX_OUT+4], cl

    shr dx, 4
    mov cx, dx
    and cx, 0x0f
    call calc_hex_digit
    mov [HEX_OUT+3], cl

    shr dx, 4
    mov cx, dx
    and cx, 0x0f
    call calc_hex_digit
    mov [HEX_OUT+2], cl

    mov ax, HEX_OUT
    call print_string

    popa
    ret

calc_hex_digit:
    cmp cl, 9
    jg alpha_hex_digit
    add cl, 0x30

alpha_hex_digit:
    add cl, 0x37
    ret


HEX_OUT: db '0x0000',0

