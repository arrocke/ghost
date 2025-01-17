[bits 32]
[extern main]

    call main
    jmp $

GLOBAL breakpoint
breakpoint:
    xchg bx, bx
    ret
