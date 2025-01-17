all: build/ghost.img

run: all
	bochs -q

build/ghost.img: build/boot/boot.bin build/kernel/kernel.bin 
	cat $^ > $@

C_SOURCES = $(wildcard kernel/*.c drivers/**/*.c)
OBJ = $(addprefix build/, $(patsubst %.c, %.o, $(C_SOURCES)))
C_HEADERS = kernel drivers $(wildcard drivers/**/ kernel/**/)

build/kernel/kernel.bin: build/kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -T linker.ld $^ --oformat binary

build/%.o: %.c
	mkdir -p $(dir $(addprefix build/, $<))
	gcc -ffreestanding -m32 -fno-pic -c $< -o $@ $(addprefix -I, $(C_HEADERS))

build/%.o: %.asm
	mkdir -p $(dir $(addprefix build/, $<))
	nasm $< -f elf32 -o $@

build/%.bin: %.asm
	mkdir -p $(dir $(addprefix build/, $<))
	nasm $< -I $(dir $<) -f bin -o $@

clean:
	rm -rf build

disassemble: build/ghost.img
	ndisasm -b 32 $< | less

