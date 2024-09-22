; TODO: 
; - print byte by byte function
; - check if proper elf magic bytes

%include "src/std.asm"

section .text
global  _start

_start:
; CHECK ARGC
  pop   rax
  cmp   rax, 2
  jne   usage

  pop   rax               ; skip argv[0]
  pop   rsi               ; rdi = argv[1]
  push  rsi               ; save it for later...
  lea   rdi,  [rel info]
  call  printc

; OPEN SAID FILE
  pop   rdi               ; filename
  xor   rsi,  rsi         ; flags = O_RDONLY (0)
  mov   rax,  0x02        ; 2 = open
  syscall

  cmp   rax,  0x00        ; check for error
  jle   exit

  mov   [fd], rax         ; store fd

; READ MAGIC 
  mov   rdi,  [fd]            ; fd
  lea   rsi,  [elfh]          ; read into this buffer
  mov   rdx,  elf64_hdr_size  ; read 4 bytes
  mov   rax,  0x00            ; sys_read
  syscall

  cmp   rax,  elf64_hdr_size 
  jne   close

  lea   rdi,  [rel magic]
  call  print

  ; PRINTH (if you see this, this doesnt work)
  mov   rdi,  [fd]
  mov   rsi,  0x00
  mov   rdx,  0x04
  call  printh

;  mov   rdi,  0x01  ; fd = stdout
;  lea   rsi,  elfh  ; buf
;  mov   rdx,  0x04  ; count
;  mov   rax,  0x01  ; sys_write
;  syscall

  mov   rdi,  0x01
  push  0x0A
  mov   rsi,  rsp
  mov   rdx,  0x02
  mov   rax,  0x01
  syscall

close:
  mov   rdi, [fd]     ; our FD
  mov   rax, 0x03     ; sys_close
  syscall

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
  call  printn

  xor   rdi,  rdi
  inc   rdi
  mov   rax,  0x3c
  syscall

section   .data
; STRINGS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
  ; USAGE
  usg1  db  "Usage: ", 0x00
  usg2  db  " <FILE>", 0x0A, 0x00

  info  db  "Opening: ", 0x00
  magic db  "Magic: ", 0x00

; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

section   .bss
  fd    resq  0x01            ; space for our FD
  elfh  resb  elf64_hdr_size  ; sizeof 64bit header

  ; define struct
struc elf64_hdr
  .e_ident:      resb 0x10
  .e_type:       resw 0x01
  .e_machine:    resw 0x01
  .e_version:    resd 0x01
  .e_entry:      resq 0x01
  .e_phoff:      resq 0x01
  .e_shoff:      resq 0x01
  .e_flags:      resd 0x01
  .e_ehsize:     resw 0x01
  .e_phentsize:  resw 0x01
  .e_phnum:      resw 0x01
  .e_shentsize:  resw 0x01
  .e_shnum:      resw 0x01
  .e_shstrndx:   resw 0x01
endstruc

; save:
; rbx, rsp, rbp, r12-r15
