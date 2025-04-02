%include "src/structs.asm"
%include "src/magic.asm"
section .text
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
  call  print
  
  movzx  rax, byte [endian]
  cmp  rax, LITTLE_ENDIAN
  je   _le
  lea  rdi, msg_big
  call print
  jmp  _next
_le:  
  lea  rdi, msg_little
  call print
_next:  

  movzx   rax, byte [bitness]
  cmp rax, BITS_32
  je _b32
  lea rdi, msg_bits64
  call println
  jmp _next2
_b32: 
  lea rdi, msg_bits32
  call println
_next2: 

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
  print_num   st_elfhdr, elf64_hdr.e_entry, 0x10

  lea   rdi,  elf_phoff
  call  print
  print_num   st_elfhdr, elf64_hdr.e_phoff, 0x10

  lea   rdi,  elf_shoff
  call  print
  print_num   st_elfhdr, elf64_hdr.e_shoff, 0x10

  lea   rdi,  elf_flags
  call  print
  lea   rdi,  st_elfhdr
  add   rdi,  elf64_hdr.e_flags
  mov   rsi,  0x04
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
  call  print
  mov   rdi, st_elfhdr
  movzx rdi, word [rdi + elf64_hdr.e_shstrndx]
  mov   rsi, rsp
  call  itoa
  mov   rdi, rsp
  call  println

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret


print_prgh:
  push  rbp
  mov   rbp,  rsp
  sub   rsp,  0x38

  lea   rdi,  prg_type
  call  println

  lea   rdi,  prg_flags
  call  print
  lea   rdi,  st_scthdr
  add   rdi,  elf64_phdr.p_flags
  mov   rsi,  0x04
  mov   rdx,  rsp
  call  hexdump
  mov   rdi,  rsp
  call  println

  lea   rdi,  prg_offset
  call  print
  print_num   st_prghdr,  elf64_phdr.p_offset, 0x10

  lea   rdi,  prg_vaddr
  call  print
  print_num   st_prghdr,  elf64_phdr.p_vaddr, 0x10

  lea   rdi,  prg_paddr
  call  print
  print_num   st_prghdr,  elf64_phdr.p_paddr, 0x10

  lea   rdi,  prg_filesz
  call  print
  print_num   st_prghdr,  elf64_phdr.p_filesz, 0x10

  lea   rdi,  prg_memsz
  call  print
  print_num   st_prghdr,  elf64_phdr.p_memsz, 0x10

  lea   rdi,  prg_align
  call  print
  print_num   st_prghdr,  elf64_phdr.p_align, 0x10

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret

print_scth:
  push  rbp
  mov   rbp,  rsp
  sub   rsp,  0x40

  lea   rdi,  sct_name
  call  println
  ;.sh_name          resd 0x01; ; dereference me - im a offset in shstrtab

  lea   rdi,  sct_type
  call  println
  ;.sh_type          resd 0x01; ; fancy output me

  lea   rdi,  sct_flags
  call  print
  ;.sh_flags         resq 0x01; ; qword - hexdump
  lea   rdi,  st_scthdr
  add   rdi,  elf64_shdr.sh_flags
  mov   rsi,  0x08
  mov   rdx,  rsp
  call  hexdump
  mov   rdi,  rsp
  call  println

  lea   rdi,  sct_addr
  call  print
  mov   r10,  0x02
  print_num   st_scthdr,  elf64_shdr.sh_addr, 0x10

  lea   rdi,  sct_offset
  call  print
  print_num   st_scthdr, elf64_shdr.sh_offset, 0x10

  lea   rdi,  sct_size
  call  print
  print_num   st_scthdr, elf64_shdr.sh_size, 0x10

  lea   rdi,  sct_link
  call  print
  print_num   st_scthdr, elf64_shdr.sh_link, 0x08

  lea   rdi,  sct_info
  call  print
  print_num   st_scthdr, elf64_shdr.sh_info, 0x08

  lea   rdi,  sct_addralign
  call  print
  print_num   st_scthdr, elf64_shdr.sh_addralign, 0x10

  lea   rdi,  sct_entsize
  call  print
  print_num   st_scthdr, elf64_shdr.sh_entsize, 0x10

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret
