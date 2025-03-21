; TODO: 
; - rewrite to use MMAP instead of SYS_READ
; - print_hex
; - check if proper elf magic bytes

; save:
; rbx, rsp, rbp, r12-r15

%include "src/macros.asm"
%include "src/structs.asm"
%include "src/std.asm"

section   .bss
  filename    resq 1
  filesize    resq 1
  fd          resq 1
  ptr_buffer  resq 1
  st_stat     resq STAT_SIZE

section   .data
; STRINGS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  ; USAGE
  usg1  db  "Usage: ", 0x00
  usg2  db  " <FILE>", 0x0A, 0x00

  info  db  "Opening: ", 0x00
  magic db  "Magic: ", 0x00

; VARIABLES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

; other stuff...

section .text
global  _start

_start:
; CHECK ARGC
  pop   rax                 ; shove argc into RAX
  cmp   rax, 2              ; if argc != 2
  jne   usage               ; go to usage prompt :)

  lea   rdi,  [rel info]    ; rdi = "opening ..."
  mov   rsi,  [rsp + 0x08]  ; rsi = argv[1]

  mov   [filename], rsi     ; filename = argv[1] (RSI), so we can use it later

  call  printc              ; printc = "print combo"- should've named it 
                            ;          printf or something... :P

  read_stat   [filename], st_stat

; TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPOR
;  mov   rdi,  [st_stat + stat.st_size]
;  jmp   exit
; TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPOR

  ; OPEN(filename, O_RDONLY);
  open  [filename], O_RDONLY
  mov   [fd], rax

  ; MMAP(NULL, st.size, PROT_READ, MAP_PRIVATE, fd, 0);
  xor   rdi,  rdi                       ; NULL
  mov   rsi,  [st_stat + stat.st_size]  ; st.size
  mov   rdx,  PROT_READ                 ; PROT_READ
  mov   r10,  MAP_PRIVATE               ; MAP_PRIVATE
  mov   r8,   [fd]                      ; fd
  xor   r9,   r9                        ; 0
  mov   rax,  SYS_MMAP
  syscall

  mov   [ptr_buffer], rax ; move pointer in rax to var that holds ptr

  ; PRINTH (if you see this, this doesnt work)
  ; mov   rdi,  [fd]
  ; mov   rsi,  0x00
  ; mov   rdx,  0x04
  ; call  printh

  ; CLOSE(fd);
  close [fd]

  ; UNMAP THE FILE
  ; MUNMAP(file, st.size)
  lea   r12,  [ptr_buffer]
  mov   rdi,  [r12]
  mov   rsi,  [st_stat + stat.st_size]
  mov   rax,  0x0B ; <- SYS_MUNMAP
  syscall

; EXIT
exit:
  xor   rdi,  rdi       ; retval
  mov   rax,  SYS_EXIT  ; sys_exit
  syscall

usage:
  lea   rdi,  usg1      ; "Usage: "
  call  print

  pop   rdi             ; argv[0]
  call  print

  lea   rdi,  usg2      ; " <FILE>"
  call  println

  xor   rdi,  rdi
  inc   rdi
  mov   rax,  0x3c
  syscall
