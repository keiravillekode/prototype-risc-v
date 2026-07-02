.equ WINK, 0b00001
.equ DOUBLE, 0b00010
.equ CLOSE, 0b00100
.equ JUMP, 0b01000
.equ REVERSE, 0b10000

.macro CONSIDER value, string
        andi    t1, a1, \value
        beqz    t1, end\@
        la      t1, \string
copy\@:
        lb      t2, 0(t1)
        sb      t2, 0(a0)
        addi    t1, t1, 1
        addi    a0, a0, 1
        bnez    t2, copy\@

        addi    a0, a0, -1
end\@:

.endm

.section .rodata
wink:   .string "wink, "
double: .string "double blink, "
close:  .string "close your eyes, "
jump:   .string "jump, "

.text
.globl commands

/* extern void commands(char *buffer, int number); */
commands:
        move    t0, a0
        andi    t1, a1, REVERSE
        bnez    t1, .reverse

        CONSIDER WINK wink
        CONSIDER DOUBLE double
        CONSIDER CLOSE close
        CONSIDER JUMP jump
        beq     a0, t0, .return

.strip:
        sb      zero, -2(a0)
        ret

.reverse:
        CONSIDER JUMP jump
        CONSIDER CLOSE close
        CONSIDER DOUBLE double
        CONSIDER WINK wink
        bne     a0, t0, .strip

.return:
        sb      zero, 0(a0)
        ret
