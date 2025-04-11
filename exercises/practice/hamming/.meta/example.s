.equ UNEQUAL_LENGTHS, -1

.text
.globl distance

/* extern int distance(const char *strand1, const char *strand2); */
distance:
        move    a2, a0
        move    a0, zero                /* accumulator */

.loop:
        lb      t1, 0(a1)
        addi    a1, a1, 1
        lb      t2, 0(a2)
        addi    a2, a2, 1
        beqz    t1, .end

        beq     t1, t2, .loop

        beqz    t2, .unequal_lengths

        addi    a0, a0, 1
        j       .loop

.end:
        bnez    t2, .unequal_lengths

        ret

.unequal_lengths:
        li      a0, UNEQUAL_LENGTHS
        ret
