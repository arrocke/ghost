# Ghost

At this point the bootloader should print "hello" and then loop forever

Compile the boot sector: `nasm boot.asm -f bin -o ghost.bin`
Run on emulator: `bochs -q`
