%include "src/std.asm"

section .text

global  _start
_start:
; ITOA (edi *num, rsi &buf, rdx sz_buf)
  mov   edi, [rel num]  ; mov number to edi
  lea   rsi, buf        ; mov buffer to esi
  mov   rdx, 0x10       ; mov buffer size to rdx
  mov   r10, 0x02       ; base (1 = 10, 2 = 16)
  call  itoa            ; call itoa

  add   rsp, 0x0C       ; clean up stack

  test  rax,  rax       ; check retval
  jnz   exit

; PRINT (rdi *buf, rsi newline)
  lea   rdi, [rel buf]  ; buf ptr
  mov   rsi, 0x01       ; newline
  call  print
  add   rsp, 0x0c

  test  rax, rax
  jnz   exit

; PRINTN (rdi *txt, rsi *num)
  lea   rdi, [rel txt]
  lea   rsi, [rel buf]
  call  printn
  add   rsp, 0x0c

  test  rax, rax
  jnz   exit

; EXIT
exit:
  xor   rdi,  rdi       ; retval
  mov   rax,  0x3c      ; sys_exit
  syscall

section   .data
  num   dd  420
  txt   db  "This is a silly number: ", 0x00

  elfh  istruc elf64_hdr iend 

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
