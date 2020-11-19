ASM = boot_sect.s
TARGET = boot_sect.bin

$(TARGET): $(ASM) 
	nasm $^ -f bin -o $(TARGET) 

PHONY: clean, run
run: 
	qemu-system-i386 $(TARGET)

clean:
	rm -f $(TARGET)
