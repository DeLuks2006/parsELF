; TODO: 
; - compare ei_data and e_machine using lookup table or something
; - handle 32bit
; - go over section headers
; - take big-endian into account
; ...
; takin some inspiration from travgm's parser: 
; - use string lookup tables instead of Hex-Only output
; - use arguments to: print all, print prghdr, print scthdr

%include "src/macros.asm"
%include "src/output.asm"
%include "src/structs.asm"
%include "src/std.asm"
%include "src/hexdump.asm"
%include "src/magic.asm"

section   .bss
; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  filename    resq  1
  filesize    resq  1
  fd          resq  1
  mapped_bin  resq  1
  st_stat     resq  STAT_SIZE
  st_elfhdr   resb  ELFHDR64_SIZE
  st_prghdr   resb  PRGHDR64_SIZE
  st_scthdr   resb  SCTHDR64_SIZE

  phnum       resw  1
  shnum       resw  1

section   .rodata
; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  valid_magic db  0x7f, 0x45, 0x4c, 0x46

; MACHINE : ENDIAN TABLE
; HOLY MOTHER OF CURSED... polprog better throw this into a seperate file or find a better way to do this
EM_TABLE	
  db	EM_NONE,        	UNKNOWN_ENDIAN
	db	EM_M32,         	BIG_ENDIAN
	db	EM_SPARC,       	BIG_ENDIAN
	db	EM_386,         	LITTLE_ENDIAN
	db	EM_68K,         	BIG_ENDIAN
	db	EM_88K,         	BIG_ENDIAN
	db	EM_IAMCU,       	LITTLE_ENDIAN
	db	EM_860,         	BIG_ENDIAN
	db	EM_MIPS,        	BIG_ENDIAN
	db	EM_S370,        	BIG_ENDIAN
	db	EM_MIPS_RS3_LE,	  LITTLE_ENDIAN
	db	EM_PARISC,	      BIG_ENDIAN
	db	EM_VPP500,	      BIG_ENDIAN
	db	EM_SPARC32PLUS,	  BIG_ENDIAN
	db	EM_960,	          BIG_ENDIAN
	db	EM_PPC,	          BIG_ENDIAN
	db	EM_PPC64,	        BIG_ENDIAN
	db	EM_S390,	        BIG_ENDIAN
	db	EM_SPU,	          BIG_ENDIAN
	db	EM_V800,	        BIG_ENDIAN
	db	EM_FR20,	        BIG_ENDIAN
	db	EM_RH32,	        BIG_ENDIAN
	db	EM_RCE,	          BIG_ENDIAN
	db	EM_ARM,	          LITTLE_ENDIAN
	db	EM_FAKE_ALPHA,	  BIG_ENDIAN
	db	EM_SH,	          BIG_ENDIAN
	db	EM_SPARCV9,	      BIG_ENDIAN
	db	EM_TRICORE,	      BIG_ENDIAN
	db	EM_ARC,	          BIG_ENDIAN
	db	EM_H8_300,	      BIG_ENDIAN
	db	EM_H8_300H,	      BIG_ENDIAN
	db	EM_H8S,	          BIG_ENDIAN
	db	EM_H8_500,	      BIG_ENDIAN
	db	EM_IA_64,	        BIG_ENDIAN
	db	EM_MIPS_X,	      BIG_ENDIAN
	db	EM_COLDFIRE,	    BIG_ENDIAN
	db	EM_68HC12,	      BIG_ENDIAN
	db	EM_MMA,	          BIG_ENDIAN
	db	EM_PCP,	          BIG_ENDIAN
	db	EM_NCPU,	        BIG_ENDIAN
	db	EM_NDR1,	        BIG_ENDIAN
	db	EM_STARCORE,	    BIG_ENDIAN
	db	EM_ME16,     	    BIG_ENDIAN
	db	EM_ST100,    	    BIG_ENDIAN
	db	EM_TINYJ,    	    BIG_ENDIAN
	db	EM_X86_64,      	LITTLE_ENDIAN
	db	EM_PDSP,        	BIG_ENDIAN
	db	EM_PDP10,       	BIG_ENDIAN
	db	EM_PDP11,       	BIG_ENDIAN
	db	EM_FX66,        	BIG_ENDIAN
	db	EM_ST9PLUS,	      BIG_ENDIAN
	db	EM_ST7,	          BIG_ENDIAN
	db	EM_68HC16,	      BIG_ENDIAN
	db	EM_68HC11,	      BIG_ENDIAN
	db	EM_68HC08,	      BIG_ENDIAN
	db	EM_68HC05,	      BIG_ENDIAN
	db	EM_SVX,	          BIG_ENDIAN
	db	EM_ST19,	        BIG_ENDIAN
	db	EM_VAX,         	BIG_ENDIAN
	db	EM_CRIS,        	LITTLE_ENDIAN
	db	EM_JAVELIN,     	BIG_ENDIAN
	db	EM_FIREPATH,    	BIG_ENDIAN
	db	EM_ZSP,         	BIG_ENDIAN
	db	EM_MMIX,        	BIG_ENDIAN
	db	EM_HUANY,       	BIG_ENDIAN
	db	EM_PRISM,       	LITTLE_ENDIAN
	db	EM_AVR,         	BIG_ENDIAN
	db	EM_FR30,    	    BIG_ENDIAN
	db	EM_D10V,     	    BIG_ENDIAN
	db	EM_D30V,     	    BIG_ENDIAN
	db	EM_V850,     	    BIG_ENDIAN
	db	EM_M32R,    	    BIG_ENDIAN
	db	EM_MN10300,  	    BIG_ENDIAN
	db	EM_MN10200,  	    BIG_ENDIAN
	db	EM_PJ,          	BIG_ENDIAN
	db	EM_OPENRISC,    	BIG_ENDIAN
	db	EM_ARC_COMPACT, 	BIG_ENDIAN
	db	EM_XTENSA,      	BIG_ENDIAN
	db	EM_VIDEOCORE,   	BIG_ENDIAN
	db	EM_TMM_GPP,     	BIG_ENDIAN
	db	EM_NS32K,       	BIG_ENDIAN
	db	EM_TPC,	          BIG_ENDIAN
	db	EM_SNP1K,	        BIG_ENDIAN
	db	EM_ST200,	        BIG_ENDIAN
	db	EM_IP2K,	        BIG_ENDIAN
	db	EM_MAX,	          BIG_ENDIAN
	db	EM_CR,	          BIG_ENDIAN
	db	EM_F2MC16,	      BIG_ENDIAN
	db	EM_MSP430,	      BIG_ENDIAN
	db	EM_BLACKFIN,	    BIG_ENDIAN
	db	EM_SE_C33,	      BIG_ENDIAN
	db	EM_SEP,	          BIG_ENDIAN
	db	EM_ARCA,	        BIG_ENDIAN
	db	EM_UNICORE,	      BIG_ENDIAN
	db	EM_EXCESS,	      BIG_ENDIAN
	db	EM_DXP,	          BIG_ENDIAN
	db	EM_ALTERA_NIOS2,	BIG_ENDIAN
	db	EM_CRX,         	BIG_ENDIAN
	db	EM_XGATE,       	BIG_ENDIAN
	db	EM_C166,        	BIG_ENDIAN
	db	EM_M16C,        	BIG_ENDIAN
	db	EM_DSPIC30F,    	BIG_ENDIAN
	db	EM_CE,          	BIG_ENDIAN
	db	EM_M32C,        	BIG_ENDIAN
	db	EM_TSK3000,     	BIG_ENDIAN
	db	EM_RS08,        	BIG_ENDIAN
	db	EM_SHARC,       	BIG_ENDIAN
	db	EM_ECOG2,       	BIG_ENDIAN
	db	EM_SCORE7,      	BIG_ENDIAN
	db	EM_DSP24,	        BIG_ENDIAN
	db	EM_VIDEOCORE3,	  BIG_ENDIAN
	db	EM_LATTICEMICO32, BIG_ENDIAN
	db	EM_SE_C17,	      BIG_ENDIAN
	db	EM_TI_C6000,	    BIG_ENDIAN
	db	EM_TI_C2000,	    BIG_ENDIAN
	db	EM_TI_C5500,	    BIG_ENDIAN
	db	EM_TI_ARP32,	    BIG_ENDIAN
	db	EM_TI_PRU,	      BIG_ENDIAN
	db	EM_MMDSP_PLUS,	  BIG_ENDIAN
	db	EM_CYPRESS_M8C,	  BIG_ENDIAN
	db	EM_R32C,	        BIG_ENDIAN
	db	EM_TRIMEDIA,	    BIG_ENDIAN
	db	EM_QDSP6,	        BIG_ENDIAN
	db	EM_8051,	        BIG_ENDIAN
	db	EM_STXP7X,	      BIG_ENDIAN
	db	EM_NDS32,	        BIG_ENDIAN
	db	EM_ECOG1X,	      BIG_ENDIAN
	db	EM_MAXQ30,	      BIG_ENDIAN
	db	EM_XIMO16,	      BIG_ENDIAN
	db	EM_MANIK,	        BIG_ENDIAN
	db	EM_CRAYNV2,	      BIG_ENDIAN
	db	EM_RX,	          BIG_ENDIAN
	db	EM_METAG,   	    BIG_ENDIAN
	db	EM_MCST_ELBRUS,	  BIG_ENDIAN
	db	EM_ECOG16,      	BIG_ENDIAN
	db	EM_CR16,	        BIG_ENDIAN
	db	EM_ETPU,        	BIG_ENDIAN
	db	EM_SLE9X,       	BIG_ENDIAN
	db	EM_L10M,        	BIG_ENDIAN
	db	EM_K10M,        	BIG_ENDIAN
	db	EM_AARCH64,     	BIG_ENDIAN
	db	EM_AVR32,       	BIG_ENDIAN
	db	EM_STM8,        	BIG_ENDIAN
	db	EM_TILE64,      	BIG_ENDIAN
	db	EM_TILEPRO,     	BIG_ENDIAN
	db	EM_MICROBLAZE,  	BIG_ENDIAN
	db	EM_CUDA,        	BIG_ENDIAN
	db	EM_TILEGX,      	BIG_ENDIAN
	db	EM_CLOUDSHIELD, 	BIG_ENDIAN
	db	EM_COREA_1ST,	    BIG_ENDIAN
	db	EM_COREA_2ND,	    BIG_ENDIAN
	db	EM_ARC_COMPACT2,	BIG_ENDIAN
	db	EM_OPEN8,	        BIG_ENDIAN
	db	EM_RL78,	        BIG_ENDIAN
	db	EM_VIDEOCORE5,    BIG_ENDIAN
	db	EM_78KOR,	        BIG_ENDIAN
	db	EM_56800EX,	      BIG_ENDIAN
	db	EM_BA1,         	BIG_ENDIAN
	db	EM_BA2,	          BIG_ENDIAN
	db	EM_XCORE,	        BIG_ENDIAN
	db	EM_MCHP_PIC,	    BIG_ENDIAN
	db	EM_KM32,	        BIG_ENDIAN
	db	EM_KMX32,	        BIG_ENDIAN
	db	EM_EMX16,	        BIG_ENDIAN
	db	EM_EMX8,	        BIG_ENDIAN
	db	EM_KVARC,	        BIG_ENDIAN
	db	EM_CDP,	          BIG_ENDIAN
	db	EM_COGE,	        BIG_ENDIAN
	db	EM_COOL,	        BIG_ENDIAN
	db	EM_NORC,	        BIG_ENDIAN
	db	EM_CSR_KALIMBA,	  BIG_ENDIAN
	db	EM_Z80,	          BIG_ENDIAN
	db	EM_VISIUM,	      BIG_ENDIAN
	db	EM_FT32,	        BIG_ENDIAN
	db	EM_MOXIE,	        BIG_ENDIAN
	db	EM_AMDGPU,  	    BIG_ENDIAN
	db	EM_RISCV,	        BIG_ENDIAN
	db	EM_BPF,	          BIG_ENDIAN
	db	EM_CSKY,	        BIG_ENDIAN

; STRINGS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  parself       db  0x0A, "           [ ParsELF - A Mini-ELF Parser ]          ", 0x0A, 0x00

  ; USAGE
  usg1  db  "Usage: ", 0x00
  usg2  db  " <FILE>", 0x0A, 0x00

  ; INFO
  info  db  "Opening: ", 0x00

  ; ERROR
  err_small       db  "[x] Filesize too small (this time size DOES MATTER)", 0x0A, 0x00
  err_magic       db  "[x] Invalid ELF magic :P", 0x0A, 0x00
  err_e_ehsize    db  "[x] Unexpected e_ehsize value", 0x0A, 0x00
  err_e_phentsize db  "[x] Unexpected e_phentsize value", 0x0A, 0x00
  err_p_offset    db  "[x] The value p_offset is greater than the filesize.", 0x0A, 0x00

  ; ELF HDR
  elf_banner    db  "______________________________________[ ELF_HEADER ]", 0x00
  elf_magic     db  `Magic:\t`, 0x00
  elf_format    db  "Format: ", 0x00 ; 32 or 64bit
  elf_endian    db  "Endian: ", 0x00 ; little or big
  elf_version   db  "Version: ", 0x00
  elf_trgt_os   db  "Target OS: ", 0x00
  elf_trgt_v    db  "Target Version: ", 0x00
  elf_filetype  db  "Type: ", 0x00 ; ET_DYN, ET_EXEC
  elf_instrset  db  "Instruction Set: ", 0x00 ; MIPS, RISCV, x86
  elf_entry     db  `Entrypoint:\t0x`, 0x00
  elf_phoff     db  `ProgHdr Offset:\t0x`, 0x00
  elf_shoff     db  `SectHdr Offset:\t0x`, 0x00
  elf_flags     db  `Flags:\t\t`, 0x00
  elf_ehsize    db  `Sizeof ELF hdr:\t0x`, 0x00
  elf_phentsize db  `Sizeof ProgHdr:\t0x`, 0x00
  elf_phnum     db  `Num Of ProgHdr:\t0x`, 0x00
  elf_shentsize db  `Sizeof SectHdr:\t0x`, 0x00
  elf_shnum     db  `Num of SectHdr:\t0x`, 0x00
  elf_shstrndx  db  "String Table Index: ", 0x00

  ; PROGRAM HDR
  prg_banner    db  "__________________________________[ PROGRAM_HEADER ]", 0x00
  prg_type      db  "Type: ", 0x00
  prg_flags     db  "Flags: ", 0x00
  prg_offset    db  "Offset: ", 0x00
  prg_vaddr     db  "Virtual Address: ", 0x00
  prg_paddr     db  "Physical Address: ", 0x00
  prg_filesz    db  "Size on Disk: ", 0x00
  prg_memsz     db  "Size in Memory: ", 0x00
  prg_align     db  "Alignment: ", 0x00

  ; SECTION HDR
  sct_banner    db  "__________________________________[ SECTION_HEADER ]", 0x00

section .text
global  _start

_start:
; CHECK ARGC
  pop   rax                 ; Shove argc into RAX
  cmp   rax, 2              ; If argc != 2
  jne   usage               ; Go to usage prompt :)

  lea   rdi,  parself
  call  println

  lea   rdi,  [rel info]    ; rdi = "opening ..."
  mov   rsi,  [rsp + 0x08]  ; rsi = argv[1]

  mov   [filename], rsi     ; Filename = argv[1]

  call  printc              ; Printc = "print combo"

; _______________________________________________________[ READING THE FILE ]_

  ; Open file for reading
  open  [filename], O_RDONLY  ; OPEN(file, O_RDONLY, 0);
  mov   [fd], rax             ; Save FD

  ; Read file size
  read_stat   [filename], st_stat

  ; check if file is big enough to store headers
  mov   rax,  [st_stat + stat.st_size]
  mov   rbx,  100 ; minimum filesize
  cmp   rax,  rbx
  jl    size_error

  ; Load the file into memory
  mmap  st_stat, [fd]         ; MMAP(0, size, PROT_READ, MAP_PRIVATE, fd, 0);
  mov   [mapped_bin], rax     ; Save loaded file in "mapped_bin"

  close [fd]

; _____________________________________________________[ PARSING ELF HEADER ]_
  
  ; Load mmap-ed file into struct
  mov   rsi,  [mapped_bin]                    ; src  = mapped_bin
  mov   rdi,  st_elfhdr                       ; dest = st_elfhdr
  movzx rcx,  word [rsi + elf64_hdr.e_ehsize] ; size = e_ehsize

  cmp   rcx,  ELFHDR64_SIZE                     ; Check if size is expected
  jne   e_ehsize_error
  
  rep   movsb

  xor   rcx,  rcx

  ; Check if correct magic bytes :)
  magic_validation:
    movzx rax,  byte [st_elfhdr+rcx]   ; read  byte
    movzx rbx,  byte [valid_magic+rcx] ; valid byte
    
    cmp   rax,  rbx
    jne   magic_error                 ; if invalid, goto error

    inc   rcx
    cmp   rcx,  0x04
    jne   magic_validation

  ; Output ELF banner
  lea   rdi,  elf_banner
  call  println

  ; Output all members of ELF header
  call  print_elfh
; ________________________________________________[ PARSING PROGRAM HEADERS ]_

  ; Output program header banner
  lea   rdi,  prg_banner
  call  println

  mov   rax,  [mapped_bin]                      ; get base
  mov   rbx,  [rax + elf64_hdr.e_phoff]         ; offset
  add   rax,  rbx                               ; 1st prghdr = base + offset 
  
  mov   rcx,  [mapped_bin]
  movzx r8,   word [rcx + elf64_hdr.e_phentsize]
  movzx rdx,   word [rcx + elf64_hdr.e_phnum] ; get e_phnum
  mov   [phnum], dx                     ; phnum

  push  0x00

  ph_loop:
    mov   rsi,  rax         ; src = mapped_bin + offset
    mov   rdi,  st_prghdr   ; dst = st_prghdr
    mov   rcx,  r8          ; size = e_phentsize

    cmp   rcx,  PRGHDR64_SIZE ; Check if size is expected
    jne   e_phentsize_error

    rep   movsb
    
    mov   r9,   [st_prghdr + elf64_phdr.p_offset]
    cmp   r9,   [st_stat + stat.st_size]
    jge   p_offset_error

    push  rax
    call  print_prgh
    pop   rax

    add   rax,  PRGHDR64_SIZE ; point RAX to next hdr
    
  ; TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY 
    push  rax
    mov   rdx,  0x02
    push  0x0A
    mov   rsi,  rsp  
    mov   rdi,  0x01
    mov   rax,  0x01
    syscall
    pop   rax
    pop   rax
  ; TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY 

    pop   rdx             ; this is dumb...
    inc   rdx             ; counter + 1
    push  rdx

    cmp   rdx,  [phnum]  ; i == e_phnum
    jne   ph_loop

; ________________________________________________[ PARSING SECTION HEADERS ]_

; ...

; ___________________________________________________________[ EXIT ROUTINE ]_

  ; UNMAP THE FILE
  munmap  [mapped_bin], st_stat

; EXIT
exit:
  xor   rdi,  rdi       ; Return value = 0
  mov   rax,  SYS_EXIT  ; sys_exit
  syscall

usage:
  lea   rdi,  usg1      ; "Usage: "
  call  print

  pop   rdi             ; argv[0]
  call  print

  lea   rdi,  usg2      ; " <FILE>"
  call  println
  jmp   error

size_error:
  lea   rdi, err_small
  call  println
  jmp   error

; Could this macro have less arguments? Yes.
; Why does it then take 3 args? Because me wanna make it * reusable & readable *. :3
magic_error:
  cleanup [mapped_bin], st_stat, err_magic

e_ehsize_error:
  cleanup [mapped_bin], st_stat, err_e_ehsize

e_phentsize_error:
  cleanup [mapped_bin], st_stat, err_e_phentsize

p_offset_error:
  cleanup [mapped_bin], st_stat, err_p_offset

error:
  xor   rdi,  rdi       
  inc   rdi             ; Return value = 1
  mov   rax,  SYS_EXIT
  syscall
