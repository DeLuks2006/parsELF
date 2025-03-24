; TODO: 
; - rewrite to use MMAP instead of SYS_READ
; - print_hex
; - check if proper elf magic bytes

%include "src/macros.asm"
%include "src/output.asm"
%include "src/structs.asm"
%include "src/std.asm"

section   .bss
; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  filename    resq  1
  filesize    resq  1
  fd          resq  1
  mapped_bin  resq  1
  st_stat     resq  STAT_SIZE
  st_elfhdr   resb  ELFHDR_SIZE

section   .data
; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  valid_magic db  0x7f, 0x45, 0x4c, 0x46
; STRINGS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  ; USAGE
  usg1  db  "Usage: ", 0x00
  usg2  db  " <FILE>", 0x0A, 0x00

  ; INFO
  info  db  "Opening: ", 0x00

  ; ERROR
  err_small db  "[x] Filesize too small (this time size DOES MATTER)", 0x0A, 0x00
  err_magic db  "[x] Invalid ELF magic :P", 0x0A, 0x00

  ; ELF HDR
  elf_banner    db  "______________________________________[ ELF_HEADER ]", 0x00
  elf_magic     db  "Magic: ", 0x00
  elf_format    db  "Format (32 or 64bit): ", 0x00
  elf_endian    db  "Endian: ", 0x00
  elf_version   db  "Version: ", 0x00
  elf_trgt_os   db  "Target OS: ", 0x00
  elf_trgt_v    db  "Target Version: ", 0x00
  ;
  elf_filetype  db  "Type: ", 0x00 ; ET_DYN, ET_EXEC
  elf_instrset  db  "Instruction Set: ", 0x00 ; MIPS, RISCV, x86
  elf_entry     db  "Entrypoint: ", 0x00
  elf_phoff     db  "ProgHdr Offset: ", 0x00
  elf_shoff     db  "SectHdr Offset: ", 0x00
  elf_flags     db  "Flags: ", 0x00
  elf_ehsize    db  "Sizeof ELF hdr: ", 0x00
  elf_phentsize db  "Sizeof ProgHdr: ", 0x00
  elf_phnum     db  "Num Of ProgHdr: ", 0x00
  elf_shentsize db  "Sizeof SectHdr: ", 0x00
  elf_shnum     db  "Num of SectHdr: ", 0x00
  elf_shstrndx  db  "String Table Index: ", 0x00

section .text
global  _start

_start:
; CHECK ARGC
  pop   rax                 ; Shove argc into RAX
  cmp   rax, 2              ; If argc != 2
  jne   usage               ; Go to usage prompt :)

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
  mov   rbx,  184 ; minimum filesize = 1 ELF hdr + 1 program hdr + 1 section hdr
  cmp   rax,  rbx
  jl    size_error

  ; Load the file into memory
  mmap  st_stat, [fd]         ; MMAP(0, size, PROT_READ, MAP_PRIVATE, fd, 0);
  mov   [mapped_bin], rax     ; Save loaded file in "mapped_bin"

; _____________________________________________________[ PARSING ELF HEADER ]_

  ; Load mmap-ed file into struct
  mov   rsi,  [mapped_bin]    ; src  = mapped_bin
  mov   rdi,  st_elfhdr       ; dest = st_elfhdr
  mov   rcx,  ELFHDR_SIZE     ; size = 64
  rep   movsb

  xor   rax,  rax
  xor   rbx,  rbx
  xor   rcx,  rcx

  ; Check if correct magic bytes :)
  magic_validation:
    mov   al,  byte [st_elfhdr+rcx]   ; read  byte
    mov   bl,  byte [valid_magic+rcx] ; valid byte
    
    cmp   rax,  rbx
    jne   magic_error                 ; if invalid, goto cleanup

    inc   rcx
    cmp   rcx,  0x04
    jne   magic_validation

  ; Output ELF Banner
  lea   rdi,  elf_banner
  call  println

  ; convert magic bytes to ascii
  ; ...

  ; later do printc "magic: ", elf
  call  print_elfh

; ___________________________________________________________[ EXIT ROUTINE ]_

cleanup:
  ; CLOSE(fd);
  close [fd]

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
  close [fd]
  
  lea   rdi, err_small
  call  println
  jmp   error

magic_error:
  close [fd]
  munmap  [mapped_bin], st_stat

  lea   rdi,  err_magic
  call  println
  jmp   error

error:
  xor   rdi,  rdi       
  inc   rdi             ; Return value = 1
  mov   rax,  SYS_EXIT
  syscall
