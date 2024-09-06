%include "src/std.asm"

section .text

global  _start
_start:
; CHECK ARGC
  pop   rax
  cmp   rax, 2
  jne   usage

  pop   rax           ; skip argv[0]
  pop   rdi           ; rdi = argv[1]
  push  rdi           ; save it for later...
  call  printn

; OPEN SAID FILE
  pop   rdi           ; filename
  ;xor   rsi,  rsi     ; flags = O_RDONLY (0)
  mov   rsi,  0x01    ; tmp
  mov   rax,  0x02    ; 2 = open
  syscall

  cmp   rax,  0x00    ; check for error
  jle   exit

; TODO:
; - read header
; - throw that data into the struct
; - print some data
; - be the coolest mf in the world

; ~ ~ ~ ~ ~ ~ ~ ~ TMP ~ ~ ~ ~ ~ ~ ~ ~

  push  rax
  mov   edi,  eax     ; num
  lea   rsi,  buf     ; buf ptr
  mov   rdx,  0x10    ; sizeof buf
  mov   r10,  0x02    ; dec or hex
  call  itoa

  lea   rdi,  [rel tmp]
  lea   rsi,  [rel buf]
  call  printc

  pop   rdi
  lea   rsi,  [rel usg2]
  mov   rdx,  0x08
  mov   rax,  0x01
  syscall

; ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

  mov   rax, 0x03
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
  mov   rax,  0x3c
  syscall

section   .data
  usg1  db  "Usage: ", 0x00
  usg2  db  " <FILE>", 0x0A, 0x00

  elfh  istruc elf64_hdr iend 

  tmp   db  "FD : ", 0x00

section   .bss
  buf   resb  0x10

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
