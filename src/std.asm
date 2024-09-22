; THIS IS NOT A SEGGSUALLY TRANSMITTABLE DISEASE
; THIS IS A FILE WITH BASIC/STANDARD FUNCTIONALITY TO MAKE MY LIFE EASIER

; ITOA ----------------------------------------------------------------------
; INT TO ASCII
; converts a number to decimal representation in ASCII

itoa:
  push  rbp
  mov   rbp,  rsp
  sub   rsp,  0x08

  mov   [rbp-0x08], rdx ; buf size

  mov   r11,  rsi       ; r11 = buff
  mov   rax,  rdi       ; rax = num

  xor   rcx,  rcx       ; clear counter

itoa_calc_loop:
  xor   rdx,  rdx       ; clear reg
  mov   rsi,  0x0A      ; rbx = base
  cmp   r10,  0x02      ; check if we want hex
  mov   r9,   0x10
  cmovz rsi,  r9        ; if zf move 16 as base

  div   rsi             ; rax = res

  cmp   rdx, 0x0A
  jge   itoa_hex
  add   rdx, '0'        ; convert to ascii

itoa_cont_loop:
  push  rdx             ; mov num to stack

  inc   rcx             ; inc counter
  test  rax, rax        ; check if res = 0
  jnz   itoa_calc_loop  ; we not done
  jmp   itoa_exit_calc  ; we done

itoa_hex:
  add   rdx, 0x37       ; if this dont work, add "A" and sub 0x0A
  jmp   itoa_cont_loop  

itoa_exit_calc:
; need for buffer size check
  inc   rcx             ; add space for \0
  mov   rax,  rcx       ; save value in rax
  dec   rcx             ; get our old value back

  cmp   rax, [rbp-0x08] ; cmp buf size with our len
  jge   itoa_buf_overflow

itoa_buf_loop:
  pop   rdx
  mov   byte [r11], dl  ; pop val to buf

  inc   r11             ; move ptr
  loop  itoa_buf_loop

  xor   rax,  rax  ; success
  mov   rsp,  rbp
  pop   rbp
  ret
  
itoa_buf_overflow:
  pop   rdi
  loop  itoa_buf_overflow 

  xor   rax,  rax  ; errror
  inc   rax
  mov   rsp,  rbp
  pop   rbp
  ret

; PRINT ---------------------------------------------------------------------
; calulates the strlen and prints the given string

print:
  push  rbp
  mov   rbp,  rsp

  mov   rax, rdi
  mov   rbx, rdi

print_len:
  cmp   byte [rax], 0x00  ; check if \0
  jz    print_len_done    ; if so jump
  inc   rax               ; inc ptr
  jmp   print_len         ; LOOP
  
print_len_done:
  sub   rax,  rbx         ; get len

  mov   rdx,  rax         ; len
  mov   rsi,  rdi         ; buf ptr
  xor   rdi,  rdi
  inc   rdi               ; stdout
  xor   rax,  rax
  inc   rax               ; sys_write
  syscall

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret

; PRINTN --------------------------------------------------------------------
; PRINT NEWLINE
; prints some text and then a newline

printn:
  push  rbp
  mov   rbp,  rsp
  
  call  print

  mov   rdx,  0x02
  push  0x0A
  mov   rsi,  rsp  
  mov   rdi,  0x01
  mov   rax,  0x01
  syscall

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret
  
; PRINTC --------------------------------------------------------------------
; PRINT COMBO
; prints rdi, then rsi and adds a newline

printc:
  push  rbp
  mov   rbp,  rsp

  push  rsi   ; save num
  call  print

  pop   rdi   ; get old num
  call  printn

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret

; PRINTH --------------------------------------------------------------------
; PRINT HEX
; prints hexdump like output

; args: rdi fd, rsi offset, rdx no_of_bytes

printh:
  push  rbp
  mov   rbp,  rsp
  sub   rbp,  0x20      ; alloc space
  sub   rbp,  rdx

  ;- VARIABLES ----------------------;
  ; rbp-0x08 = fd                    ;
  ; rbp-0x10 = offset                ; 
  ; rbp-0x18 = count                 ;
  ; rbp-0x20 = byte                  ;
  ; rbp-0x?? = buff   ( 0x20 + rdx ) ;
  ; rcx = n                          ;
  ;----------------------------------;

  mov   [rbp-0x08], rdi ; fd
  mov   [rbp-0x10], rsi ; offset
  mov   [rbp-0x18], rdx ; no of bytes
  
; lseek(fd, offset, SEEK_SET);
  mov   rdi,  [rbp-0x08]  ; FD
  mov   rsi,  [rbp-0x10]  ; OFFSET
  xor   rdx,  rdx         ; SEEK_SET
  mov   rax,  0x08        ; LSEEK
  syscall

; read(fd, buffer, length);
  mov   rdi,  [rbp-0x08]      ; FD
  mov   rdx,  [rbp-0x18]      ; COUNT
  ; at this point i feel like im writing bs
  ; so i stop
  mov   rsi,  [rbp-rdx-0x20]  ; BUF
  xor   rax,  rax             ; READ
  syscall

  xor   rcx,  rcx
printh_loop:
  mov   rax,  rsi
  add   rax,  rcx
  mov   byte  rdx,  [rax]
;  void print_hex(int fd, int offset, int length) {
;  --* SNIP *--
;    loopy_loop:
;       byte = *buffer + n;
;       printf("%x", byte);
;       printf(" ");
;       n++;
;
;       if (n <= length) {
;         goto loopy_loop;
;       }
;
;    puts("");
;  }

  xor   rax,  rax
  mov   rsp,  rbp
  pop   rbp
  ret
