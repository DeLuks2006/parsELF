; TODO: 
; - rewrite to use MMAP instead of SYS_READ
; - print_hex
; - check if proper elf magic bytes

; save:
; rbx, rsp, rbp, r12-r15

%include "src/macros.asm"
%include "src/structs.asm"
%include "src/std.asm"

section   .bss
  filename resq 1
  fd       resq 1

section   .data
; STRINGS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  ; USAGE
  usg1  db  "Usage: ", 0x00
  usg2  db  " <FILE>", 0x0A, 0x00

  info  db  "Opening: ", 0x00
  magic db  "Magic: ", 0x00

; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

; other stuff...

section .text
global  _start

_start:
; CHECK ARGC
  pop   rax
  cmp   rax, 2
  jne   usage

  mov   rsi, [rsp + 0x08]   ; rdi = argv[1]
  mov   [filename], rsi     ; save for later...

  lea   rdi,  [rel info]
  call  printc

  ; struct stat st_stat;
  ; STAT(filename, &st_stat);

  ; OPEN(filename, O_RDONLY);
  open  filename, O_RDONLY
  mov   [fd], rax

  ; MMAP(NULL, st.size, PROT_READ, MAP_PRIVATE, fd, 0);

  ; PRINTH (if you see this, this doesnt work)
  ; mov   rdi,  [fd]
  ; mov   rsi,  0x00
  ; mov   rdx,  0x04
  ; call  printh

  ; UNMAP THE FILE
  ; MUNMAP(file, st.size)

  ; CLOSE THE FILE
  ; CLOSE(fd);
  close fd

; EXIT
exit:
  xor   rdi,  rdi     ; retval
  mov   rax,  0x3c    ; sys_exit
  syscall

usage:
  lea   rdi,  usg1    ; "Usage: "
  xor   rsi,  rsi
  call  print

  pop   rdi           ; argv[0]
  xor   rsi,  rsi
  call  print

  lea   rdi,  usg2    ; " <FILE>"
  xor   rsi,  rsi
  call  println

  xor   rdi,  rdi
  inc   rdi
  mov   rax,  0x3c
  syscall
