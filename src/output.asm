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
  call  print
  
  ; load byte(st_elfhdr+4)
  movzx rdi,  byte [st_elfhdr + 4]
  cmp   rdi,  0x01
  je    .elf_print_32
  cmp   rdi,  0x02
  je    .elf_print_64
  jmp   .elf_print_invalid_format

  .elf_print_32:
    lea   rdi,  elf_32bit
    call  println
    jmp   .elf_print_endian

  .elf_print_64:
    lea   rdi,  elf_64bit
    call  println
    jmp   .elf_print_endian

  .elf_print_invalid_format:
    lea   rdi,  elf_invalid
    call  println
  
  .elf_print_endian:
  lea   rdi,  elf_endian
  call  print

  movzx rdi,  byte [st_elfhdr + 5]
  cmp   rdi,  0x01
  je    .elf_print_lil
  cmp   rdi,  0x02
  je    .elf_print_big
  jmp   .elf_print_invalid_endian

  .elf_print_lil:
    lea   rdi,  elf_lil_end
    call  println
    jmp   .elf_print_version

  .elf_print_big:
    lea   rdi,  elf_big_end
    call  println
    jmp   .elf_print_version

  .elf_print_invalid_endian:
    lea   rdi,  elf_invalid
    call  println

  .elf_print_version:
  lea   rdi,  elf_version
  call  print
  print_num   st_elfhdr,  0x06, 0x10

  lea   rdi,  elf_trgt_os
  call  print
  print_num   st_elfhdr,  0x07, 0x10

  lea   rdi,  elf_filetype
  call  print

  movzx rdi,  word [st_elfhdr + elf64_hdr.e_type]
  cmp   rdi,  0x01
  je    .elf_print_rel_type
  cmp   rdi,  0x02
  je    .elf_print_exec_type
  cmp   rdi,  0x03
  je    .elf_print_dyn_type
  cmp   rdi,  0x04
  je    .elf_print_core_type
  jmp   .elf_print_unknown_type
  
  .elf_print_rel_type:
    lea   rdi,  elf_et_rel
    call  println
    jmp   .elf_print_instrset

  .elf_print_exec_type:
    lea   rdi,  elf_et_exec
    call  println
    jmp   .elf_print_instrset

  .elf_print_dyn_type:
    lea   rdi,  elf_et_dyn
    call  println
    jmp   .elf_print_instrset

  .elf_print_core_type:
    lea   rdi,  elf_et_core
    call  println
    jmp   .elf_print_instrset

  .elf_print_unknown_type:
    lea   rdi,  elf_unknown
    call  println

  .elf_print_instrset:
  lea   rdi,  elf_instrset
  call  print
  print_num   st_elfhdr, elf64_hdr.e_machine, 0x10

  lea   rdi,  elf_trgt_v
  call  print
  print_num   st_elfhdr,  elf64_hdr.e_version, 0x0F ; idk why but i need to make the buffer smaller here

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
  call  print

  xor   rdi,  rdi
  mov   edi,  dword [st_prghdr]
  cmp   edi,  0x00  ; null
  je    .prg_print_null_type
  cmp   edi,  0x01  ; load
  je    .prg_print_load_type
  cmp   edi,  0x02  ; dyn
  je    .prg_print_dyn_type
  cmp   edi,  0x03  ; interp
  je    .prg_print_interp_type
  cmp   edi,  0x04  ; note
  je    .prg_print_note_type
  cmp   edi,  0x05  ; shlib
  je    .prg_print_shlib_type
  cmp   edi,  0x06  ; phdr
  je    .prg_print_phdr_type
  cmp   edi,  0x07  ; tls
  je    .prg_print_tls_type
  jmp   .prg_print_unknown_type ; unknown value

  .prg_print_null_type:
    lea   rdi,  prg_pt_null
    call  println
    jmp   .prg_print_flags

  .prg_print_load_type:
    lea   rdi,  prg_pt_load
    call  println
    jmp   .prg_print_flags

  .prg_print_dyn_type:
    lea   rdi,  prg_pt_dyn
    call  println
    jmp   .prg_print_flags
  
  .prg_print_interp_type:
    lea   rdi,  prg_pt_interp
    call  println
    jmp   .prg_print_flags

  .prg_print_note_type:
    lea   rdi,  prg_pt_note
    call  println
    jmp   .prg_print_flags
  
  .prg_print_shlib_type:
    lea   rdi,  prg_pt_shlib
    call  println
    jmp   .prg_print_flags

  .prg_print_phdr_type:
    lea   rdi,  prg_pt_phdr
    call  println
    jmp   .prg_print_flags

  .prg_print_tls_type:
    lea   rdi,  prg_pt_tls
    call  println
    jmp   .prg_print_flags

  .prg_print_unknown_type:
    lea   rdi,  elf_unknown
    call  println

  .prg_print_flags:
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
  call  print
  ;.sh_type          resd 0x01; ; fancy output me
  mov   edi,  dword [st_scthdr + elf64_shdr.sh_type]
  cmp   edi,  0x00
  je    .sct_print_null
  cmp   edi,  0x01
  je    .sct_print_progbits
  cmp   edi,  0x02
  je    .sct_print_symtab
  cmp   edi,  0x03
  je    .sct_print_strtab
  cmp   edi,  0x04
  je    .sct_print_rela
  cmp   edi,  0x5
  je    .sct_print_hash
  cmp   edi,  0x6
  je    .sct_print_dynamic
  cmp   edi,  0x7
  je    .sct_print_note
  cmp   edi,  0x8
  je    .sct_print_nobits
  cmp   edi,  0x9
  je    .sct_print_rel
  cmp   edi,  0x0A
  je    .sct_print_shlib
  cmp   edi,  0x0B
  je    .sct_print_dynsym
  cmp   edi,  0x0E
  je    .sct_print_init_array
  cmp   edi,  0x0F
  je    .sct_print_fini_array
  cmp   edi,  0x10
  je    .sct_print_preinit_array
  cmp   edi,  0x11
  je    .sct_print_group
  cmp   edi,  0x12
  je    .sct_print_symtab_shndx
  cmp   edi,  0x13
  je    .sct_print_num
  cmp   edi,  0x60000000
  je    .sct_print_loos
  jmp   .sct_print_unknown

  .sct_print_null:
    lea   rdi,  sct_st_null
    call  println
    jmp   .sct_print_flags
  .sct_print_progbits:
    lea   rdi,  sct_st_prgbts
    call  println
    jmp   .sct_print_flags
  .sct_print_symtab:
    lea   rdi,  sct_st_symtab
    call  println
    jmp   .sct_print_flags
  .sct_print_strtab:
    lea   rdi,  sct_st_strtab
    call  println
    jmp   .sct_print_flags
  .sct_print_rela:
    lea   rdi,  sct_st_rela
    call  println
    jmp   .sct_print_flags
  .sct_print_hash:
    lea   rdi,  sct_st_hash
    call  println
    jmp   .sct_print_flags
  .sct_print_dynamic:
    lea   rdi,  sct_st_dyn
    call  println
    jmp   .sct_print_flags
  .sct_print_note:
    lea   rdi,  sct_st_note
    call  println
    jmp   .sct_print_flags
  .sct_print_nobits:
    lea   rdi,  sct_st_nobits
    call  println
    jmp   .sct_print_flags
  .sct_print_rel:
    lea   rdi,  sct_st_rel
    call  println
    jmp   .sct_print_flags
  .sct_print_shlib:
    lea   rdi,  sct_st_shlib
    call  println
    jmp   .sct_print_flags
  .sct_print_dynsym:
    lea   rdi,  sct_st_dysym
    call  println
    jmp   .sct_print_flags
  .sct_print_init_array:
    lea   rdi,  sct_st_inarr
    call  println
    jmp   .sct_print_flags
  .sct_print_fini_array:
    lea   rdi,  sct_st_fiarr
    call  println
    jmp   .sct_print_flags
  .sct_print_preinit_array: 
    lea   rdi,  sct_st_piarr
    call  println
    jmp   .sct_print_flags
  .sct_print_group:
    lea   rdi,  sct_st_group
    call  println
    jmp   .sct_print_flags
  .sct_print_symtab_shndx:
    lea   rdi,  sct_st_shndx
    call  println
    jmp   .sct_print_flags
  .sct_print_num:
    lea   rdi,  sct_st_num
    call  println
    jmp   .sct_print_flags
  .sct_print_loos:
    lea   rdi,  sct_st_loos
    call  println
    jmp   .sct_print_flags
  .sct_print_unknown:
    lea   rdi,  elf_unknown
    call  println

  .sct_print_flags:
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
