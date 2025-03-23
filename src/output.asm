%include "src/structs.asm"

print_elfh:
  push  rbp
  mov   rbp,  rsp
  sub   rbp,  0x00

  ; later call itoh and printc
  lea   rdi,  elf_magic
  call  println

  lea   rdi,  elf_format
  call  println

  lea   rdi,  elf_endian
  call  println

  lea   rdi,  elf_version
  call  println

  lea   rdi,  elf_trgt_os
  call  println

  lea   rdi,  elf_trgt_v
  call  println
  
  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret
