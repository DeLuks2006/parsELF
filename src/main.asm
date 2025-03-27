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

section   .data

  counter dd 0

section   .rodata
; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  valid_magic db  0x7f, 0x45, 0x4c, 0x46

; MACHINE : ENDIAN TABLE
; insert here later

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

  mov   r12,  [mapped_bin]                      ; get base
  mov   rbx,  [r12 + elf64_hdr.e_phoff]         ; offset
  add   r12,  rbx                               ; 1st prghdr = base + offset 
  
  mov   rcx,  [mapped_bin]
  movzx r8,   word [rcx + elf64_hdr.e_phentsize]
  movzx rdx,   word [rcx + elf64_hdr.e_phnum] ; get e_phnum
  mov   [phnum], dx                     ; phnum

  ph_loop:
    mov   rsi,  r12         ; src = mapped_bin + offset
    mov   rdi,  st_prghdr   ; dst = st_prghdr
    mov   rcx,  r8          ; size = e_phentsize

    cmp   rcx,  PRGHDR64_SIZE ; Check if size is expected
    jne   e_phentsize_error

    rep   movsb
    
    mov   r9,   [st_prghdr + elf64_phdr.p_offset]
    cmp   r9,   [st_stat + stat.st_size]
    jge   p_offset_error

    call  print_prgh

    add   r12,  PRGHDR64_SIZE ; point RAX to next hdr
    
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

    inc   dword [counter] ; counter + 1
    push  r12
    mov   r12d, [counter]
    cmp   r12,  [phnum]  ; i == e_phnum
    pop   r12
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
