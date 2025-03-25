;;; Hexdump.asm - x86 hexdump procedure
;;; produces a hexdump of a given bufer in the form of AA BB CD EF
;;; polprog 21.03.2025
;;; rdi - pointer to buffer
;;; rsi - length
;;; rdx  - ptr to target buffer, needs to be at least 3*length+1
hexdump:
  ;; bl - nibble
  mov rcx, rsi
_hexdump_byte:	
  mov al, [rdi] 		; al contains the first byte
  shr al, 4		; place upper nibble in al
  call nib2asc		; nibble to ascii, returns in *rdx++
  
  mov al, [rdi]		; load lower nibble to al and repeat
  and al, 0x0f 		; the conversion
  call nib2asc		; nibble to ascii, returns in *rdx++
  
  inc rdi			; next byte
  mov [rdx], byte ' '	; place space
  inc rdx
  loop _hexdump_byte	

  mov [rdx], byte 0x00 	; null terminate the string
  ret

nib2asc:	
  add al, '0'		; convert to char 0-9
  ;;  if al > '9', then add enough to move it up to the letters
  cmp al, '9'		; compare
  jle _belowten
  add al, 7		
_belowten:
  ;; now al contains the character, move it to the target buffer
  mov [rdx], al
  inc rdx
  ret
