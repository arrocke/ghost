SECTIONS {
    . = 0x1000;  /* The kernel will be loaded into 0x1000 */
    
    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }
}
