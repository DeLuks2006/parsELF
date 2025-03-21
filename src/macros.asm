; SYSCALLS -------------------------------------------------------------------
%define SYS_OPEN  0x02
%define SYS_CLOSE 0x03
%define SYS_STAT  0x04
%define SYS_MMAP  0x09

%define SYS_EXIT  0x3c

; FLAGS ----------------------------------------------------------------------
; open specific
%define O_RDONLY    0x00  ; read-only flag
; mmap specific
%define PROT_READ   0x01
%define MAP_PRIVATE 0x02

; WRAPPERS -------------------------------------------------------------------
%macro open 2           ; open(filename, flags)
  mov   rdi, %1         ; 1st arg: filename pointer
  mov   rsi, %2         ; 2nd arg: flags
  xor   rdx, rdx        ; 3rd arg: mode (not needed for O_RDONLY)
  mov   rax, SYS_OPEN   ; syscall number
  syscall
%endmacro

%macro close 1
  mov   rdi, %1         ; 1st arg: fd
  mov   rax, SYS_CLOSE  ; close(fd)
  syscall
%endmacro

%macro read_stat 2
  mov   rdi,  %1        ; 1st arg: address of filename string
  mov   rsi,  %2        ; 2nd arg: address of stat structure
  mov   rax,  SYS_STAT
  syscall
%endmacro
