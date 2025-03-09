#ifndef print_h
#include "elf.h"

const char* get_eh_osabi(uint32_t os_abi);
const char* get_eh_type(uint16_t type);
const char* get_ph_type(uint32_t type); 
const char* get_sh_type(uint32_t type);
void printELF(Elf64_Ehdr* elf_header);
void printPH(Elf64_Phdr* program_header);
void printSH(Elf64_Shdr* section_header);
#endif // !print_h
