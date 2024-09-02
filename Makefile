ASM = nasm
AFLAGS = -f elf64
LD = ld
SRC = src/main.asm
OUT = main

all:
	@echo "[#] Assembling..."
	$(ASM) $(AFLAGS) $(SRC) -o $(OUT).o
	@echo "[#] Linking..."
	$(LD) -o $(OUT) $(OUT).o

debug:
	@echo "[#] Assembling..."
	$(ASM) $(AFLAGS) $(SRC) -o $(OUT).o -g
	@echo "[#] Linking..."
	$(LD) -o $(OUT) $(OUT).o -g

clean:
	rm $(OUT).o $(OUT)
