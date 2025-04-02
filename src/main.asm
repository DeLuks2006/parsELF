; TODO: 
; - compare ei_data and e_machine using lookup table or something
; - handle 32bit
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

extern banner

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
  flags   db 0
  endian  db 0x55
  bitness db 0x55

section   .rodata
; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  valid_magic db  0x7f, 0x45, 0x4c, 0x46

; MACHINE : ENDIAN TABLE
; insert here later

; STRINGS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  parself       db  0x0A,"                       [ ParsELF – A NASM-ELF Parser ]", 0x0A, 0x00

  ; USAGE
  usg1  db  "Usage: ./parself <FILE> [FLAGS]", 0x00
  help_menu db  `\nFlags:\n`
            db  `\t-x - print banner\n`
            db  `\t-h - print this help menu\n`
            db  `\t-e - print ELF header\n`
            db  `\t-p - print program headers\n`
            db  `\t-s - print section headers\n`, 0x00

  ; INFO
  info  db  "Opening: ", 0x00

  ; ERROR
  err_small       db  "[x] Filesize too small (this time size DOES MATTER)", 0x0A, 0x00
  err_magic       db  "[x] Invalid ELF magic :P", 0x0A, 0x00
  err_e_phoff     db  "[x] The offset to the program headers is invalid.", 0x0A, 0x00
  err_e_phnum     db  "[x] Invalid e_phnum value", 0x0A, 0x00
  err_e_ehsize    db  "[x] Unexpected e_ehsize value", 0x0A, 0x00
  err_e_phentsize db  "[x] Unexpected e_phentsize value", 0x0A, 0x00
  err_p_offset    db  "[x] The value p_offset is greater than the filesize.", 0x0A, 0x00
  err_e_shoff     db  "[x] The offset to the section headers is invalid.", 0x0A, 0x00
  err_e_shnum     db  "[x] Invalid e_shnum", 0x0A, 0x00
  err_e_shentsize db  "[x] Unexpected e_shentsize value", 0x0A, 0x00
  err_sh_offset   db  "[x] The value sh_offset is greater than the filesize.", 0x0A, 0x00

  ; ELF HDR
  elf_banner    db  "________________________________________________________________[ ELF HEADER ]", 0x00
  elf_magic     db  `Magic:\t\t\t`, 0x00
  elf_format    db  `Format: `, 0x00 ; 32 or 64bit
  elf_endian    db  `Endian: \t\t`, 0x00 ; little or big
  msg_little    db  `little, `, 0x00 
  msg_big       db  `big, `, 0x00
  msg_bits32    db  `32-bit`, 0x00
  msg_bits64    db  `64-bit`, 0x00
  elf_version   db  `Version: `, 0x00
  elf_trgt_os   db  `Target OS: `, 0x00
  elf_trgt_v    db  `Target Version: `, 0x00
  elf_filetype  db  `Type: `, 0x00 ; ET_DYN, ET_EXEC
  elf_instrset  db  `Instruction Set: `, 0x00 ; MIPS, RISCV, x86
  elf_entry     db  `Entrypoint:\t\t0x`, 0x00
  elf_phoff     db  `ProgHdr Offset:\t\t0x`, 0x00
  elf_shoff     db  `SectHdr Offset:\t\t0x`, 0x00
  elf_flags     db  `Flags:\t\t\t`, 0x00
  elf_ehsize    db  `Sizeof ELF hdr:\t\t0x`, 0x00
  elf_phentsize db  `Sizeof ProgHdr:\t\t0x`, 0x00
  elf_phnum     db  `Num Of ProgHdr:\t\t0x`, 0x00
  elf_shentsize db  `Sizeof SectHdr:\t\t0x`, 0x00
  elf_shnum     db  `Num of SectHdr:\t\t0x`, 0x00
  elf_shstrndx  db  `String Table Index:\t0x`, 0x00

  ; PROGRAM HDR
  prg_banner    db  "___________________________________________________________[ PROGRAM_HEADERS ]", 0x00
  prg_type      db  `Type: `, 0x00
  prg_flags     db  `Flags:\t\t\t`, 0x00
  prg_offset    db  `Offset:\t\t\t0x`, 0x00
  prg_vaddr     db  `Virtual Address:\t0x`, 0x00
  prg_paddr     db  `Physical Address:\t0x`, 0x00
  prg_filesz    db  `Size on Disk:\t\t0x`, 0x00
  prg_memsz     db  `Size in Memory:\t\t0x`, 0x00
  prg_align     db  `Alignment:\t\t0x`, 0x00

  ; SECTION HDR
  sct_banner    db  "___________________________________________________________[ SECTION_HEADERS ]", 0x00
  sct_name      db `Name: `, 0x00
  sct_type      db `Type: `, 0x00
  sct_flags     db `Flags:\t\t`, 0x00
  sct_addr      db `Address:\t0x`, 0x00
  sct_offset    db `Offset:\t\t0x`, 0x00
  sct_size      db `Size:\t\t0x`, 0x00
  sct_link      db `Link:\t\t0x`, 0x00
  sct_info      db `Info:\t\t0x`, 0x00
  sct_addralign db `Alignment:\t0x`, 0x00
  sct_entsize   db `Entry Size:\t0x`, 0x00

section .text
global  _start

_start:
; CHECK ARGC
  pop   rax                 ; Shove argc into RAX
  cmp   rax, 0x02           ; If argc <= 2
  jl    usage               ; Go to usage prompt :)

  mov   rsi,  [rsp + 0x08]  ; argv[1]
  mov   [filename], rsi     ; filename = argv[1]

  cmp   byte [rsi], '-'
  je    usage

  pop   rcx                 ; get rid of argv[0]
  pop   rcx                 ; get rid of argv[1]

  sub   rax,  0x02

  mov   [counter],  rax
  cmp   rax,  0x00
  je   .set_all

  xor   rcx,  rcx
  
  ; NOTE: maybe later rewrite below to jmp-table (somehow)
  .parse_args:
    pop   rax
    inc   rax                       ; skip '-'
    
    movzx rax,  byte [rax]          ; get char
    
    cmp   al, 'x'
    je    .set_banner
    cmp   al, 'h'
    je    .set_help
    cmp   al, 'e'
    je    .set_elfh
    cmp   al, 'p'
    je    .set_prgh
    cmp   al, 's'
    je    .set_scth

    jmp   .set_help

    .parse_next_arg:

    movzx r15, byte [counter]
    inc   rcx                       ; counter + 1
    cmp   rcx, r15                  ; counter == 0
    jne   .parse_args               ; if not go again
    jmp   .exit_parse_args

.set_elfh:
  or    byte [flags],     ENABLE_ELFH
  jmp .parse_next_arg

.set_prgh:
  or    byte [flags],     ENABLE_PRGH
  jmp .parse_next_arg

.set_scth:
  or    byte [flags],     ENABLE_SCTH
  jmp .parse_next_arg

.set_help:
  or    byte [flags],     HELP_MENU
  jmp .parse_next_arg

.set_banner:
  or    byte [flags],     0x10
  jmp .parse_next_arg

.set_all:
  mov   byte  [flags],    ENABLE_ALL

.exit_parse_args:
  mov   dword [counter],  0x00
  
; ------------------------------
  movzx rax,  byte [flags]
  mov   rbx,  HELP_MENU
  and   rax,  rbx
  cmp   rax,  0x00            ; if -h flag used
  jne   usage                 ; goto help menu

  movzx rax,  byte [flags]
  mov   rbx,  0x10
  and   rax,  rbx
  cmp   rax,  0x00
  je    skip_banner

  lea   rdi,  banner
  call  print

  lea   rdi,  parself
  call  println

  lea   rdi,  [rel info]      ; rdi = "opening ..."
  mov   rsi,  [rel filename]  ; rsi = argv[1]

  call  printc              ; Printc = "print combo"

  movzx rax,  byte [flags]
  mov   rbx,  0x07
  xor   rax,  rbx
  cmp   rax,  0x17
  jl    skip_banner

  or    byte [flags], 0x0F

skip_banner:

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
  
  ; Test e_machine (offset 16)
  movzx   rdi,  word [rsi + elf64_hdr.e_machine]     ; The offset is the same for 32/64 bit files
  ; XXX: This is swapped for BE files (eg, MIPS)
  ; ex. loading a MIPS binary results in rdi = 0x0800 instead of 0x08 here


  call get_bitness
  mov  [endian], al
  mov  [bitness], bl
  ;;mov   rsi,  [mapped_bin]                    ; src  = mapped_bin
  mov   rdi,  st_elfhdr                       ; dest = st_elfhdr
    
  cmp   rbx,  BITS_32
  je _check_ehsize_b32
  movzx rcx,  word [rsi + elf64_hdr.e_ehsize] ; size = e_ehsize
  cmp   rcx,  ELFHDR64_SIZE                     ; Check if size is expected
  jne   e_ehsize_error
  jmp   _check_ehsize_end
_check_ehsize_b32: 
  movzx rcx,  word [rsi + elf32_hdr.e_ehsize] ; size = e_ehsize
  cmp   rcx, ELFHDR32_SIZE
  jne   e_ehsize_error
_check_ehsize_end: 
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

  ; Check if we want to output elf header
  check_flag ENABLE_ELFH, skip_elfh

  ; Output ELF banner
  lea   rdi,  elf_banner
  call  println

  ; Output all members of ELF header
  call  print_elfh

skip_elfh:
  check_flag  ENABLE_PRGH, skip_prgh
; ________________________________________________[ PARSING PROGRAM HEADERS ]_

  ; Output program header banner
  lea   rdi,  prg_banner
  call  println

  mov   r12,  [st_elfhdr + elf64_hdr.e_phoff]   ; offset
  cmp   r12,  [st_stat + stat.st_size]
  jge   e_phoff_error
  cmp   r12,  0x00
  jle   e_phoff_error

  add   r12,  [mapped_bin]                      ; get base
  
  mov   rcx,  [mapped_bin]
  movzx r8,   word [rcx + elf64_hdr.e_phentsize]
  movzx rdx,  word [rcx + elf64_hdr.e_phnum]      ; get e_phnum
  mov   [phnum],  dx                     ; phnum

  cmp   dx,  0x00
  jle    e_phnum_error
  cmp   r8,  0x00
  jle    e_phentsize_error


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
skip_prgh:
  check_flag ENABLE_SCTH, skip_scth

  lea   rdi,  sct_banner
  call  println

  mov   r12,  [st_elfhdr + elf64_hdr.e_shoff]
  cmp   r12,  [st_stat + stat.st_size]
  jge   e_shoff_error
  cmp   r12,  0x00
  jle   e_shoff_error

  add   r12,  [mapped_bin]

  mov   rcx,  [mapped_bin]
  movzx r8,   word  [rcx + elf64_hdr.e_shentsize]
  movzx rdx,  word  [rcx + elf64_hdr.e_shnum]
  mov   [shnum], dx

  cmp   dx,  0x00
  jle    e_shnum_error
  cmp   r8,  0x00
  jle    e_shentsize_error

  mov   dword [counter], 0x00

  sh_loop:
    mov   rsi,  r12
    mov   rdi,  st_scthdr
    mov   rcx,  r8

    cmp   rcx,  SCTHDR64_SIZE
    jne   e_shentsize_error

    rep   movsb

    mov   r9,   [st_scthdr + elf64_shdr.sh_offset] ; I do errors
    mov   r10,  [st_stat + stat.st_size]
    cmp   r9,   [st_stat + stat.st_size]
    jge   sh_offset_error

    call  print_scth

    add   r12,  SCTHDR64_SIZE ; point RAX to next hdr

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

    inc   dword [counter]
    push  r12
    mov   r12d, [counter]
    cmp   r12,  [shnum]
    pop   r12
    jne   sh_loop

; ___________________________________________________________[ EXIT ROUTINE ]_
skip_scth:
  ; UNMAP THE FILE
  munmap  [mapped_bin], st_stat

; EXIT
exit:
  xor   rdi,  rdi       ; Return value = 0
  mov   rax,  SYS_EXIT  ; sys_exit
  syscall

usage:
  lea   rdi,  usg1      ; "Usage: ./parself ..."
  call  println

  lea   rdi,  help_menu ;
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

e_phoff_error:
  cleanup [mapped_bin], st_stat, err_e_phoff

e_phnum_error:
  cleanup [mapped_bin], st_stat, err_e_phnum

e_phentsize_error:
  cleanup [mapped_bin], st_stat, err_e_phentsize

p_offset_error:
  cleanup [mapped_bin], st_stat, err_p_offset

e_shoff_error:
  cleanup [mapped_bin], st_stat, err_e_shoff

e_shnum_error:
  cleanup [mapped_bin], st_stat, err_e_shnum

e_shentsize_error:
  cleanup [mapped_bin], st_stat, err_e_shentsize

sh_offset_error:
  cleanup [mapped_bin], st_stat, err_sh_offset

error:
  xor   rdi,  rdi       
  inc   rdi             ; Return value = 1
  mov   rax,  SYS_EXIT
  syscall


;; search the e_machine:bitness list and return the result
;; rdi = e_machine type
;; returns in rax
get_bitness:  
  mov r8, machine_bits_map
next_machine: 
  movzx r9, byte [r8]
  cmp rdi, r9
  je found
  add r8, 3  ;; skip to next entry
  cmp r8, machine_bits_map_end
  je error

found:  
  movzx rax, byte [r8+1] ; rax = endianess
  movzx rbx, byte [r8+2] ; rbx = bitness
  ret
