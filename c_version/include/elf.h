#ifndef elf_h
#define elf_h
#include <fcntl.h>
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/mman.h>

// ELF header
typedef struct {
  unsigned char e_ident[16];
  uint16_t      e_type;
  uint16_t      e_machine;
  uint32_t      e_version;
  uint64_t      e_entry;
  uint64_t      e_phoff;
  uint64_t      e_shoff;
  uint32_t      e_flags;
  uint16_t      e_ehsize;
  uint16_t      e_phentsize;
  uint16_t      e_phnum;
  uint16_t      e_shentsize;
  uint16_t      e_shnum;
  uint16_t      e_shstrndx;
} Elf64_Ehdr;

// program header
typedef struct {
  uint32_t  p_type;
  uint32_t  p_flags;
  uint64_t  p_offset;
  uint64_t  p_vaddr;
  uint64_t  p_paddr;
  uint64_t  p_filesz;
  uint64_t  p_memsz;
  uint64_t  p_align;
} Elf64_Phdr;

typedef struct {
  uint32_t   sh_name;
  uint32_t   sh_type;
  uint64_t   sh_flags;
  uint64_t   sh_addr;
  uint64_t   sh_offset;
  uint64_t   sh_size;
  uint32_t   sh_link;
  uint32_t   sh_info;
  uint64_t   sh_addralign;
  uint64_t   sh_entsize;
} Elf64_Shdr;

#endif
