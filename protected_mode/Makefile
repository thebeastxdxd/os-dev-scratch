ASM = boot_sect.s 
TARGET = boot_sect.bin
DEPS = ../real_mode/print_string.asm gdt.s print_string_pm.s protected_mode.s

$(TARGET): $(ASM) 
	nasm $^ -f bin -o $(TARGET) 

PHONY: clean, run
run: 
	qemu-system-i386 $(TARGET)

clean:
	rm -f $(TARGET)
