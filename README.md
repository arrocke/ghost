# Ghost

At this point the bootloader should get to the C kernel and print an X in the top left corner

Compile the boot sector: `nasm boot.asm -f bin -o boot.bin`
Compile the kernel object file: `gcc -ffreestanding -c kernel.c -o kernel.o`
Compile the kernel_entry object file: `nasm kernel_entry.asm -f elf64 -o kernel_entry.o`
Link the kernel entry and kernel object files: `ld -o kernel.bin -T linker.ld kernel_entry.o kernel.o --oformat binary`
Append kernel to bootloader: `cat boot.bin kernel.bin > ghost.img`
Run on emulator: `bochs -q`
