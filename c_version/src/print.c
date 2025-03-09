#include "../include/print.h"

const char* get_eh_osabi(uint32_t os_abi) {
  switch (os_abi) {
    case 0x00: return "System V";
    case 0x01: return	"HP-UX";
    case 0x02: return	"NetBSD";
    case 0x03: return	"Linux";
    case 0x04: return	"GNU Hurd";
    case 0x06: return	"Solaris";
    case 0x07: return "AIX (Monterey)";
    case 0x08: return	"IRIX";
    case 0x09: return	"FreeBSD";
    case 0x0A: return	"Tru64";
    case 0x0B: return	"Novell Modesto";
    case 0x0C: return	"OpenBSD";
    case 0x0D: return	"OpenVMS";
    case 0x0E: return	"NonStop Kernel";
    case 0x0F: return	"AROS";
    case 0x10: return	"FenixOS";
    case 0x11: return	"Nuxi CloudABI";
    case 0x12: return	"Stratus Technologies OpenVOS";
    default: return "UNKNOWN";
  };
}

const char* get_eh_type(uint16_t type) {
  switch (type) {
    case 0x00: return	"ET_NONE";
    case 0x01: return	"ET_REL";
    case 0x02: return	"ET_EXEC";
    case 0x03: return	"ET_DYN";
    case 0x04: return	"ET_CORE";
    case 0xFE00: return	"ET_LOOS";
    case 0xFEFF: return	"ET_HIOS";
    case 0xFF00: return	"ET_LOPROC";
    case 0xFFFF: return	"ET_HIPROC";
    default: return "UNKNOWN";
  };
}
const char* get_eh_machine(uint32_t machine) {
  switch (machine) {
    case 0x00: return	"No specific instruction set";
    case 0x01: return	"AT&T WE 32100";
    case 0x02: return	"SPARC";
    case 0x03: return	"x86";
    case 0x04: return	"Motorola 68000 (M68k)";
    case 0x05: return	"Motorola 88000 (M88k)";
    case 0x06: return	"Intel MCU";
    case 0x07: return	"Intel 80860";
    case 0x08: return	"MIPS";
    case 0x09: return	"IBM System/370";
    case 0x0A: return	"MIPS RS3000 Little-endian";
    case 0x0B: return "Reserved for future use";
    case 0x0E: return "Reserved for future use";
    case 0x0F: return	"Hewlett-Packard PA-RISC";
    case 0x13: return	"Intel 80960";
    case 0x14: return	"PowerPC";
    case 0x15: return	"PowerPC (64-bit)";
    case 0x16: return	"S390, including S390x";
    case 0x17: return	"IBM SPU/SPC";
    case 0x18: return "Reserved for future use";
    case 0x23: return "Reserved for future use";
    case 0x24: return	"NEC V800";
    case 0x25: return	"Fujitsu FR20";
    case 0x26: return	"TRW RH-32";
    case 0x27: return	"Motorola RCE";
    case 0x28: return	"Arm (up to Armv7/AArch32)";
    case 0x29: return	"Digital Alpha";
    case 0x2A: return	"SuperH";
    case 0x2B: return	"SPARC Version 9";
    case 0x2C: return	"Siemens TriCore embedded processor";
    case 0x2D: return	"Argonaut RISC Core";
    case 0x2E: return	"Hitachi H8/300";
    case 0x2F: return	"Hitachi H8/300H";
    case 0x30: return	"Hitachi H8S";
    case 0x31: return	"Hitachi H8/500";
    case 0x32: return	"IA-64";
    case 0x33: return	"Stanford MIPS-X";
    case 0x34: return	"Motorola ColdFire";
    case 0x35: return	"Motorola M68HC12";
    case 0x36: return	"Fujitsu MMA Multimedia Accelerator";
    case 0x37: return	"Siemens PCP";
    case 0x38: return	"Sony nCPU embedded RISC processor";
    case 0x39: return	"Denso NDR1 microprocessor";
    case 0x3A: return	"Motorola Star*Core processor";
    case 0x3B: return	"Toyota ME16 processor";
    case 0x3C: return	"STMicroelectronics ST100 processor";
    case 0x3D: return	"Advanced Logic Corp. TinyJ embedded processor family";
    case 0x3E: return	"AMD x86-64";
    case 0x3F: return	"Sony DSP Processor";
    case 0x40: return	"Digital Equipment Corp. PDP-10";
    case 0x41: return	"Digital Equipment Corp. PDP-11";
    case 0x42: return	"Siemens FX66 microcontroller";
    case 0x43: return	"STMicroelectronics ST9+ 8/16 bit microcontroller";
    case 0x44: return	"STMicroelectronics ST7 8-bit microcontroller";
    case 0x45: return	"Motorola MC68HC16 Microcontroller";
    case 0x46: return	"Motorola MC68HC11 Microcontroller";
    case 0x47: return	"Motorola MC68HC08 Microcontroller";
    case 0x48: return	"Motorola MC68HC05 Microcontroller";
    case 0x49: return	"Silicon Graphics SVx";
    case 0x4A: return	"STMicroelectronics ST19 8-bit microcontroller";
    case 0x4B: return	"Digital VAX";
    case 0x4C: return	"Axis Communications 32-bit embedded processor";
    case 0x4D: return	"Infineon Technologies 32-bit embedded processor";
    case 0x4E: return	"Element 14 64-bit DSP Processor";
    case 0x4F: return	"LSI Logic 16-bit DSP Processor";
    case 0x8C: return	"TMS320C6000 Family";
    case 0xAF: return	"MCST Elbrus e2k";
    case 0xB7: return	"Arm 64-bits (Armv8/AArch64)";
    case 0xDC: return	"Zilog Z80";
    case 0xF3: return	"RISC-V";
    case 0xF7: return	"Berkeley Packet Filter";
    case 0x101: return "WDC 65C816";
    case 0x102: return "LoongArch ";
    default: return "UNKNOWN";
  };
}
const char* get_ph_type(uint32_t type) {
  switch(type) {
    case 0:              return "PT_NULL";
    case 1:              return "PT_LOAD";
    case 2:              return "PT_DYNAMIC";
    case 3:              return "PT_INTERP";
    case 4:              return "PT_NOTE";
    case 5:              return "PT_SHLIB";
    case 6:              return "PT_PHDR";
    case 7:              return "PT_TLS";
    case 8:              return "PT_NUM";
    case 0x60000000:     return "PT_LOOS";
    case 0x6474e550:     return "PT_GNU_EH_FRAME";
    case 0x6474e551:     return "PT_GNU_STACK";
    case 0x6474e552:     return "PT_GNU_RELRO";
    case 0x6474e553:     return "PT_GNU_PROPERTY";
    case 0x6474e554:     return "PT_GNU_SFRAME";
    case 0x6ffffffa:     return "PT_LOSUNW / PT_SUNWBSS";
    case 0x6ffffffb:     return "PT_SUNWSTACK";
    case 0x6fffffff:     return "PT_HISUNW / PT_HIOS";
    case 0x70000000:     return "PT_LOPROC";
    case 0x7fffffff:     return "PT_HIPROC";
    default: return "UNKNOWN";
  };
}

const char* get_sh_type(uint32_t type) {
  switch (type) {
    case 0: return "SHT_NULL";
    case 1: return "SHT_PROGBITS";
    case 2: return "SHT_SYMTAB";
    case 3: return "SHT_STRTAB";
    case 4: return "SHT_RELA";
    case 5: return "SHT_HASH";
    case 6: return "SHT_DYNAMIC";
    case 7: return "SHT_NOTE";
    case 8: return "SHT_NOBITS";
    case 9: return "SHT_REL";
    case 10: return "SHT_SHLIB";
    case 11: return "SHT_DYNSYM";
    case 14: return "SHT_INIT_ARRAY";
    case 15: return "SHT_FINI_ARRAY";
    case 16: return "SHT_PREINIT_ARRAY";
    case 17: return "SHT_GROUP";
    case 18: return "SHT_SYMTAB_SHNDX";
    case 19: return "SHT_RELR";
    case 20: return	"SHT_NUM";
    case 0x60000000: return "SHT_LOOS";
    case 0x6ffffff5: return "SHT_GNU_ATTRIBUTES";
    case 0x6ffffff6: return "SHT_GNU_HASH";
    case 0x6ffffff7: return "SHT_GNU_LIBLIST";
    case 0x6ffffff8: return "SHT_CHECKSUM";
    case 0x6ffffffa: return "SHT_LOSUNW / SHT_SUNW_move";
    case 0x6ffffffb: return "SHT_SUNW_COMDAT";
    case 0x6ffffffc: return "SHT_SUNW_syminfo";
    case 0x6ffffffd: return "SHT_GNU_verdef";
    case 0x6ffffffe: return "SHT_GNU_verneed";
    case 0x6fffffff: return "SHT_GNU_versym / SHT_HISUNW / SHT_HIOS";
    case 0x70000000: return "SHT_LOPROC";
    case 0x7fffffff: return "SHT_HIPROC";
    case 0x80000000: return "SHT_LOUSER";
    case 0x8fffffff: return "SHT_HIUSER";
    default: return "UNKNOWN";
  }
}

void printELF(Elf64_Ehdr* elf_header) {
  puts("");
  printf("ELF Header = %02X %02X %02X %02X\n", 
         elf_header->e_ident[0], 
         elf_header->e_ident[1], 
         elf_header->e_ident[2], 
         elf_header->e_ident[3]
  );
  printf("format: %s\n", (elf_header->e_ident[4] == 1)?"32-bit":(elf_header->e_ident[4] == 2)?"64-bit":"Unknown");
  printf("endian: %s\n", (elf_header->e_ident[5] == 1)?"little":(elf_header->e_ident[4] == 2)?"big":"Unknown");
  printf("version: 0x%02x\n", elf_header->e_ident[6]);
  printf("target os: %s (0x%02x)\n", get_eh_osabi(elf_header->e_ident[7]), elf_header->e_ident[7]);
  printf("target version: 0x%02x\n", elf_header->e_ident[8]);
  printf("file type: %s (0x%02x)\n", get_eh_type(elf_header->e_type), elf_header->e_type);
  printf("instruction set: %s (0x%02x)\n", get_eh_machine(elf_header->e_machine) ,elf_header->e_machine);
  printf("entry point: 0x%lx\n", elf_header->e_entry);
  printf("program header offset: 0x%lx\n", elf_header->e_phoff);
  printf("section header offset: 0x%lx\n", elf_header->e_shoff);
  printf("flags: 0x%x\n", elf_header->e_flags);
  printf("size of ELF header: 0x%x\n", elf_header->e_ehsize);
  printf("size of program header entry: 0x%x\n", elf_header->e_phentsize);
  printf("number of program header entries: 0x%x\n", elf_header->e_phnum);
  printf("size of section header entry: 0x%x\n", elf_header->e_shentsize);
  printf("number of section header entries: 0x%x\n", elf_header->e_shnum);
  printf("section header string table index: 0x%x\n", elf_header->e_shstrndx);
  puts("");
}

void printPH(Elf64_Phdr* program_header) { 
  puts("");
  printf("type: %s (0x%X)\n", get_ph_type(program_header->p_type), program_header->p_type);
  printf("flags: 0x%X\n", program_header->p_flags);
  printf("file offset: 0x%lX\n", program_header->p_offset);
  printf("virtual addr: 0x%lX\n", program_header->p_vaddr);
  printf("physical addr: 0x%lX\n", program_header->p_paddr);
  printf("sizeof image in segment: 0x%lX\n", program_header->p_filesz);
  printf("sizeof image in memory: 0x%lX\n", program_header->p_memsz);
  printf("alignment: 0x%lX\n", program_header->p_align);
  puts("");
}

void printSH(Elf64_Shdr* section_header) {
  printf("type: %s\n", get_sh_type(section_header->sh_type));
  printf("flags: 0x%lX\n", section_header->sh_flags);
  printf("address: 0x%lX\n", section_header->sh_addr);
  printf("offset: 0x%lX\n", section_header->sh_offset);
  printf("section size: 0x%lX\n", section_header->sh_size);
  printf("link: 0x%X\n", section_header->sh_link);
  printf("info: 0x%X\n", section_header->sh_info);
  printf("alignment: 0x%lX\n", section_header->sh_addralign);
  printf("entry size: 0x%lx\n", section_header->sh_entsize);
  puts("");
}
