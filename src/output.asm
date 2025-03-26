%include "src/structs.asm"

print_elfh:
  push  rbp
  mov   rbp,  rsp
  sub   rsp,  0x80        ;allocate buffer for hexdump

  ; later call itoh and printc
  lea   rdi,  elf_magic
  call  print

  mov   rdi, [mapped_bin]
  mov   rsi, 0x10
  mov   rdx, rsp
  call  hexdump
  mov   rdi, rsp
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
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_entry
  mov   rdi, [rdi]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_phoff
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_phoff
  mov   rdi, [rdi]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_shoff
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_shoff
  mov   rdi, [rdi]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_flags
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_flags
  mov   rsi, 0x4
  mov   rdx, rsp
  call  hexdump
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_ehsize
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_ehsize
  movzx rdi, word [rdi]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_phentsize
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_phentsize
  movzx rdi, word [rdi]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_phnum
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_phnum
  movzx rdi, word [rdi]
  mov   rsi, rsp
  call itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_shentsize
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_shentsize
  movzx rdi, word [rdi]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_shnum
  call  print
  mov   rdi, [mapped_bin]
  add   rdi, elf64_hdr.e_shnum
  movzx rdi, word [rdi]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
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
