ASM = nasm
AFLAGS = -f elf64 -g
LD = ld
SRC = src/main.asm
OUT = main

all:
	@echo "[#] Assembling..."
	$(ASM) $(AFLAGS) $(SRC) -o $(OUT).o
	@echo "[#] Linking..."
	$(LD) -o $(OUT) $(OUT).o

clean:
	rm $(OUT).o -f $(OUT)
