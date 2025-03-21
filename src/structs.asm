; THIS FILE IS INTENDED FOR STRUCT DEFINITIONS

; yes I generated this structure with AI because I am lazy
struc stat
    .st_dev         resq 1  ; Device ID
    .st_ino         resq 1  ; Inode number
    .st_nlink       resq 1  ; Number of hard links
    .st_mode        resd 1  ; File mode (permissions)
    .st_uid         resd 1  ; User ID of owner
    .st_gid         resd 1  ; Group ID of owner
    .st_rdev        resq 1  ; Device ID (if special file)
    .st_size        resq 1  ; File size in bytes
    .st_blksize     resq 1  ; Block size for filesystem I/O
    .st_blocks      resq 1  ; Number of blocks allocated
    .st_atime       resq 1  ; Last access time (seconds)
    .st_atime_nsec  resq 1  ; Nanoseconds part of atime
    .st_mtime       resq 1  ; Last modification time (seconds)
    .st_mtime_nsec  resq 1  ; Nanoseconds part of mtime
    .st_ctime       resq 1  ; Last status change time (seconds)
    .st_ctime_nsec  resq 1  ; Nanoseconds part of ctime
endstruc

%define STAT_SIZE 16

; this one I did manually!!
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
