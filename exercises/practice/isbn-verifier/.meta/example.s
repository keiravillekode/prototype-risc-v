.text
.globl is_valid

/* extern int is_valid(const char *isbn); */
is_valid:
        move    t0, zero                /* sum of digits */
        move    t1, zero                /* weighted sum of digits */
        li      t2, 10                  /* number of remaining digits required */
        li      t5, 10
        li      t6, '-'

.read:
        lb      t3, 0(a0)
        addi    a0, a0, 1               /* increment input pointer */
        beq     t3, t6, .read           /* hyphen */

        beqz    t3, .end

        addi    t2, t2, -1              /* decrement number of remaining digits */
        addi    t4, t3, -'0'
        bltu    t4, t5, .digit

        bnez    t2, .reject

        li      t5, 'X'
        li      t4, 10
        bne     t3, t5, .reject

.digit:
        add     t0, t0, t4              /* update sum */
        add     t1, t1, t0              /* update weighted sum */
        j       .read

.end:
        bnez    t2, .reject             /* check number of digits */

        li      t5, 11
        rem     t1, t1, t5              /* mod 11 */
        sltiu   a0, t1, 1
        ret

.reject:
        move    a0, zero
        ret
