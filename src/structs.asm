%ifndef __STRUCTS_ASM
%define __STRUCTS_ASM
; THIS FILE IS INTENDED FOR STRUCT DEFINITIONS

; This one I stole from TMZ's "Nasty"
struc stat
    .st_dev         resq 0x01
    .st_ino         resq 0x01
    .st_nlink       resq 0x01
    .st_mode        resd 0x01
    .st_uid         resd 0x01
    .st_gid         resd 0x01
    .padding        resb 0x04
    .st_rdev        resq 0x01
    .st_size        resq 0x01
    .st_blksize     resq 0x01
    .st_blocks      resq 0x01
    .st_atime       resq 0x01
    .st_atime_nsec  resq 0x01
    .st_mtime       resq 0x01
    .st_mtime_nsec  resq 0x01
    .st_ctime       resq 0x01
    .st_ctime_nsec  resq 0x01
endstruc

%define STAT_SIZE 16

; this one I did myself!!
struc elf64_hdr
    .e_ident        resb 0x10 ; ELF Magic and other good stuff :)
    .e_type         resw 0x01
    .e_machine      resw 0x01
    .e_version      resd 0x01
    .e_entry        resq 0x01 ; Entry :3
    .e_phoff        resq 0x01 ; Wow a program header offset
    .e_shoff        resq 0x01 ; Wow++ a section header offset
    .e_flags        resd 0x01
    .e_ehsize       resw 0x01
    .e_phentsize    resw 0x01 ; sizeof(program_header)
    .e_phnum        resw 0x01 ; num of program headers
    .e_shentsize    resw 0x01 ; sizeof(section header)
    .e_shnum        resw 0x01 ; num of section headers
    .e_shstrndx     resw 0x01 ; section header string table index
endstruc

%define ELFHDR64_SIZE 64

struc elf32_hdr
    .e_ident        resb 0x10 ; ELF Magic and other good stuff :)
    .e_type         resw 0x01
    .e_machine      resw 0x01
    .e_version      resd 0x01
    .e_entry        resd 0x01 ; Entry :3
    .e_phoff        resd 0x01 ; Wow a program header offset
    .e_shoff        resd 0x01 ; Wow++ a section header offset
    .e_flags        resd 0x01
    .e_ehsize       resw 0x01
    .e_phentsize    resw 0x01 ; sizeof(program_header)
    .e_phnum        resw 0x01 ; num of program headers
    .e_shentsize    resw 0x01 ; sizeof(section header)
    .e_shnum        resw 0x01 ; num of section headers
    .e_shstrndx     resw 0x01 ; section header string table index
endstruc

%define ELFHDR32_SIZE 52

struc elf64_phdr
    .p_type         resd 0x01 ; type of phdr
    .p_flags        resd 0x01 ; flags
    .p_offset       resq 0x01 ; offset to data
    .p_vaddr        resq 0x01 ; put the segment here
    .p_paddr        resq 0x01 ; undefined for sysv
    .p_filesz       resq 0x01 ; size of segment in file
    .p_memsz        resq 0x01 ; size of segment in memory
    .p_align        resq 0x01 ; required alignment
endstruc

%define PRGHDR64_SIZE 56

struc elf32_phdr
    .p_type         resd 0x01 ; type of phdr
    .p_offset       resd 0x01 ; offset to data
    .p_vaddr        resd 0x01 ; put the segment here
    .p_paddr        resd 0x01 ; undefined for sysv
    .p_filesz       resd 0x01 ; size of segment in file
    .p_memsz        resd 0x01 ; size of segment in memory
    .p_flags        resd 0x01 ; flags
    .p_align        resd 0x01 ; required alignment
endstruc

%define PRGHDR32_SIZE 32

struc elf64_shdr
  .sh_name          resd 0x01
  .sh_type          resd 0x01
  .sh_flags         resq 0x01
  .sh_addr          resq 0x01
  .sh_offset        resq 0x01
  .sh_size          resq 0x01
  .sh_link          resd 0x01
  .sh_info          resd 0x01
  .sh_addralign     resq 0x01
  .sh_entsize       resq 0x01
endstruc

%define SCTHDR64_SIZE 64

struc elf32_shdr
  .sh_name          resd 0x01
  .sh_type          resd 0x01
  .sh_flags         resd 0x01
  .sh_addr          resd 0x01
  .sh_offset        resd 0x01
  .sh_size          resd 0x01
  .sh_link          resd 0x01
  .sh_info          resd 0x01
  .sh_addralign     resd 0x01
  .sh_entsize       resd 0x01
endstruc

%define SCTHDR32_SIZE 40

; ENDIAN PARSING ----------------------------

struc ep_table
  .ep_arch    resb  0x01
  .ep_endian  resb  0x01
endstruc

%define EPTAB_SIZE 2


; ELF32/64 handling for offset tables  

; Offset table for ELF32 and ELF64 structs
; There are 3 fields which are different size in 32 and 64 bit files
; They are marked with ! here


; names of the fields and their indexes in the offset table
%define OFF_E_IDENT 0
%define OFF_E_TYPE  1
%define OFF_E_MACHINE 2
%define OFF_E_VERSION 3
%define OFF_E_ENTRY   4
%define OFF_E_PHOFF   5
%define OFF_E_SHOFF   6
%define OFF_E_FLAGS   7
%define OFF_E_EHSIZE  8
%define OFF_E_PHENTSIZE 9
%define OFF_E_PHNUM  10
%define OFF_E_SHENTSIZE 11
%define OFF_E_SHSTRNDX 12

section .data
; This table contains the offsets for 32 bit ELFs
  elf32_ehdr_offsets db 0                  ; uchar[16] e_ident  +16
  db 16                 ; uint16_t e_type    +2
  db 18                 ; uint16_t e_machine +2
  db 20                 ; uint32_t e_version +4
  db 24                 ; uint32_t e_entry   +4  !
  db 28                 ; uint32_t e_phoff   +4  !
  db 32                 ; uint32_t e_shoff   +4  !
  db 36                 ; uint32_t e_flags   +4
  db 40                 ; uint16_t e_ehsize  +2
  db 42                 ; uint16_t e_phentsize +2
  db 44                 ; uint16_t e_phnum   +2
  db 46                 ; uint16_t e_shentsize +2
  db 48                 ; uint16_t e_shstrndx +2

; This table contains the offsets for 64 bit ELFs
  elf64_ehdr_offsets db 0                  ; uchar[16] e_ident  +16
  db 16                 ; uint16_t e_type    +2
  db 18                 ; uint16_t e_machine +2
  db 20                 ; uint32_t e_version +4
  db 24                 ; uint64_t e_entry   +8  !
  db 32                 ; uint32_t e_phoff   +8  !
  db 40                 ; uint32_t e_shoff   +8  !
  db 48                 ; uint32_t e_flags   +4
  db 52                 ; uint16_t e_ehsize  +2
  db 54                 ; uint16_t e_phentsize +2
  db 56                 ; uint16_t e_phnum   +2
  db 58                 ; uint16_t e_shentsize +2
  db 60                 ; uint16_t e_shstrndx +2


%endif
