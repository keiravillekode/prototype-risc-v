.equ ONGOING, 0
.equ DRAW, 1
.equ WIN, 2
.equ INVALID, 3

.section .rodata

/* bitsets representing horizontal, vertical and diagonal lines */
lines: .hword 0x007, 0x070, 0x700, 0x111, 0x222, 0x444, 0x124, 0x421, 0

.text
.globl gamestate

/* extern int gamestate(const char *board); */
gamestate:
        la      a1, lines
        li      a2, 'X'
        li      a3, 'O'
        move    t0, zero                /* bitset representing X marks on board */
        move    t1, zero                /* bitset representing O marks on board */
        move    t2, zero                /* number of X marks on board */
        move    t3, zero                /* number of O marks on board */
        j       .read

.update:
        beq     t4, a2, .x
        bne     t4, a3, .read

.o:
        ori     t1, t1, 1
        addi    t3, t3, 1
        j       .read

.x:
        ori     t0, t0, 1
        addi    t2, t2, 1

.read:
        slli    t0, t0, 1
        slli    t1, t1, 1
        lb      t4, 0(a0)               /* read board */
        addi    a0, a0, 1
        bnez    t4, .update

        bgt     t1, t0, .invalid        /* number of O marks > number of X marks */

        addi    t1, t1, 1
        bgt     t0, t1, .invalid        /* number of X marks > 1 + number of O */

        srli    t0, t0, 2
        srli    t1, t1, 2



        move    a0, t0
        ret

.invalid:
        li      a0, INVALID
        ret
