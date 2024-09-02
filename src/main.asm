%include "src/std.asm"

section .text

global  _start
_start:
; ITOA (edi *num, rsi &buf, rdx sz_buf)
  mov   edi, [rel num]  ; mov number to edi
  lea   rsi, buf        ; mov buffer to esi
  mov   rdx, 0x10       ; mov buffer size to rdx
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

; EXIT
exit:
  xor   rdi,  rdi       ; retval
  mov   rax,  0x3c      ; sys_exit
  syscall

section   .data
  num   dd  420

section   .bss
  buf   resb  0x10

; save:
; rbx, rsp, rbp, r12-r15
