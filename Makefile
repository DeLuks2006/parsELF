ASM = nasm
AFLAGS = -f elf64 -g
LD = ld
CODE_SRC = src/main.asm
CODE_LNK = src/main.o
BANNER_SRC = src/banner.asm
BANNER_LNK = src/banner.o
OUT = parself

all:
	@echo "[#] Assembling..."
	$(ASM) $(AFLAGS) $(CODE_SRC) -o $(CODE_LNK)
	$(ASM) $(AFLAGS) $(BANNER_SRC) -o $(BANNER_LNK)
	@echo "[#] Linking..."
	$(LD) -o $(OUT) $(CODE_LNK) $(BANNER_LNK)

clean:
	rm -f $(OUT) $(CODE_LNK) $(BANNER_LNK)
