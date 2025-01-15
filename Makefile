all: build/ghost.img

run: all
	bochs -q

build/ghost.img: build/boot/boot.bin build/kernel/kernel.bin 
	cat $^ > $@

C_SOURCES = $(wildcard kernel/*.c)
OBJ = $(addprefix build/, $(patsubst %.c, %.o, $(C_SOURCES)))

$(info $(OBJ))

build/kernel/kernel.bin: build/kernel/kernel_entry.o ${OBJ}
	ld -o $@ -T linker.ld $^ --oformat binary

build/%.o: %.c
	mkdir -p $(dir $(addprefix build/, $<))
	gcc -ffreestanding -c $< -o $@

build/%.o: %.asm
	mkdir -p $(dir $(addprefix build/, $<))
	nasm $< -f elf64 -o $@

build/%.bin: %.asm
	mkdir -p $(dir $(addprefix build/, $<))
	nasm $< -I $(dir $<) -f bin -o $@

clean:
	rm -rf build
