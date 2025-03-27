%include "src/structs.asm"

print_elfh:
  push  rbp
  mov   rbp,  rsp
  sub   rsp,  0x80        ;allocate buffer for hexdump

  ; later call itoh and printc
  lea   rdi,  elf_magic
  call  print

  mov   rdi, st_elfhdr
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
  lea   rdi,  st_elfhdr
  mov   rdi,  [rdi + elf64_hdr.e_entry]
  mov   rsi,  rsp
  call  itoa
  mov   rdi,  rsp
  call  println

  lea   rdi,  elf_phoff
  call  print
  mov   rdi,  st_elfhdr
  mov   rdi,  [rdi + elf64_hdr.e_phoff]
  mov   rsi,  rsp
  call  itoa
  mov   rdi,  rsp
  call  println

  lea   rdi,  elf_shoff
  call  print
  lea   rdi,  st_elfhdr
  mov   rdi,  [rdi + elf64_hdr.e_shoff]
  mov   rsi,  rsp
  call  itoa
  mov   rdi,  rsp
  call  println

  lea   rdi,  elf_flags
  call  print
  lea   rdi,  st_elfhdr
  add   rdi,  elf64_hdr.e_flags
  mov   rsi,  0x4
  mov   rdx,  rsp
  call  hexdump
  mov   rdi,  rsp
  call  println

  lea   rdi,  elf_ehsize
  call  print
  lea   rdi,  st_elfhdr
  movzx rdi,  word [rdi + elf64_hdr.e_ehsize]
  mov   rsi,  rsp
  call  itoa
  mov   rdi,  rsp
  call  println

  lea   rdi,  elf_phentsize
  call  print
  mov   rdi,  st_elfhdr
  movzx rdi,  word [rdi + elf64_hdr.e_phentsize]
  mov   rsi,  rsp
  call  itoa
  mov   rdi,  rsp
  call  println

  lea   rdi,  elf_phnum
  call  print
  mov   rdi,  st_elfhdr
  movzx rdi,  word [rdi + elf64_hdr.e_phnum]
  mov   rsi,  rsp
  call itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_shentsize
  call  print
  mov   rdi, st_elfhdr
  movzx rdi, word [rdi + elf64_hdr.e_shentsize]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
  call  println

  lea   rdi,  elf_shnum
  call  print
  mov   rdi, st_elfhdr
  movzx rdi, word [rdi + elf64_hdr.e_shnum]
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
  ;sub   rbp,  0x38 ;<--- this fuck makes everything crash

  lea   rdi,  prg_type
  call  println

  lea   rdi,  prg_flags
  call  println

  lea   rdi,  prg_offset
  call  println
  ;mov   rdi,  st_prghdr
  ;movzx rdi,  word [rdi + elf64_phdr.p_offset]
  ;mov   rsi,  rsp
  ;call  itoa
  ;mov   rdi,  rsp
  ;call  println

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
