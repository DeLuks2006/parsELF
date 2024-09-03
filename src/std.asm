; THIS IS NOT A SEGGSUALLY TRANSMITTABLE DISEASE
; THIS IS A FILE WITH BASIC/STANDARD FUNCTIONALITY TO MAKE MY LIFE EASIER

; ITOA ----------------------------------------------------------------------
itoa:
  push  rbp
  mov   rbp,  rsp
  sub   rsp,  0x08

  mov   [rbp-0x08], rdx ; buf size

  mov   r11,  rsi       ; r11 = buff
  mov   rax,  rdi       ; rax = num

  xor   rcx,  rcx       ; clear counter

itoa_calc_loop:
  xor   rdx, rdx        ; clear reg
  mov   rsi, 0x0A       ; rbx = base
  div   rsi             ; rax = res

  add   rdx, '0'        ; convert to ascii
  push  rdx             ; mov num to stack

  inc   rcx             ; inc counter
  test  rax, rax        ; check if res = 0
  jnz   itoa_calc_loop

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
; TODO: MAKE LESS UGLY...
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

  cmp   rsi, 0x01         ; check if we want newline
  je    print_newline_add
  jmp   print_out

print_newline_add:
  mov   byte [rbx+rax], 0x0A

print_out:
  add   rax,  0x02        ; so it prints the \n\0
  mov   rdx,  rax         ; len
  mov   rsi,  rdi         ; buf ptr
  xor   rdi,  rdi
  inc   rdi               ; stdout
  xor   rax,  rax
  inc   rax               ; sys_write
  syscall

  xor   rax, rax
  mov   rsp, rbp
  pop   rbp
  ret
