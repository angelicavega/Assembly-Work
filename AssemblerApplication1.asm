;This file deals with handling directives through Assembly
; AssemblerApplication1.asm
;
; Author : av3387a
;
;; Replace with your application code
.cseg
.def
nums = r16
.org
0x0000
rjmp
setup
.org
0x0200
digits:
.db
0b01111110, 0b00001100, 0b10110110, ob10011110, 0b11001100,
ob11011010, ob11111010, 0b11111110, 0b11001110
;These represent digits 0-9
.macro
set_pointer
ldi
@0, low(@2)
ldi
@1, high(@2)
.endmacro
setup:
ldi
nums, 0b11111111
sts
PORTA_DIR, nums
set_pointer
ZL, ZH, digits*2
loop:
1pm
r16, Z+
sts
PORTA_OUT, r16
rcall delay
rjmp
loop
delay:
nop
re
