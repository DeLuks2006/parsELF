
%define SYS_OPEN  0x2
%define SYS_CLOSE 0x3


%define O_RDONLY  0       ; read-only flag

%macro open 2             ; open(filename, flags)
  mov rdi, %1             ; first argument: filename pointer
  mov rsi, %2             ; second argument: flags
  xor rdx, rdx            ; third argument: mode (not needed for O_RDONLY)
  mov rax, SYS_OPEN       ; syscall number
  syscall
%endmacro

%macro close 1
  mov rdi, %1
  mov rax, SYS_CLOSE
  syscall
%endmacro
