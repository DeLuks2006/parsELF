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
  
  lea   rdi,  elf_filetype
  call  println

  lea   rdi,  elf_instrset
  call  println

  lea   rdi,  elf_entry
  call  println

  lea   rdi,  elf_phoff
  call  println

  lea   rdi,  elf_shoff
  call  println

  lea   rdi,  elf_flags
  call  println

  lea   rdi,  elf_ehsize
  call  println

  lea   rdi,  elf_phentsize
  call  println

  lea   rdi,  elf_phnum
  call  println

  lea   rdi,  elf_shentsize
  call  println

  lea   rdi,  elf_shnum
  call  println

  lea   rdi,  elf_shstrndx
  call  println

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret


print_prgh:
  push  rbp
  mov   rbp,  rsp
  sub   rbp,  0x00

  lea   rdi,  prg_type
  call  println

  lea   rdi,  prg_flags
  call  println

  lea   rdi,  prg_offset
  call  println

  lea   rdi,  prg_vaddr
  call  println

  lea   rdi,  prg_paddr
  call  println

  lea   rdi,  prg_filesz
  call  println

  lea   rdi,  prg_memsz
  call  println

  lea   rdi,  prg_align
  call  println

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret
