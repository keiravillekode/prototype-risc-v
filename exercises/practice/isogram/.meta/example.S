.text
.globl is_isogram

/* extern int is_isogram(const char *phrase); */
is_isogram:
        move    t0, zero                /* set of letters seen */
        li      t5, 1
        li      t6, 26
        j       .read

.update:
        ori     t1, t1, 32              /* force lower-case */
        addi    t1, t1, -'a'
        bgeu    t1, t6, .read           /* not alphabetic? */

        sll     t2, t5, t1
        move    t3, t0
        or      t0, t0, t2
        bne     t0, t3, .read           /* has set changed? */

        move    a0, zero
        ret

.read:
        lb      t1, 0(a0)
        addi    a0, a0, 1               /* increment input pointer */
        bnez    t1, .update

        li      a0, 1
        ret
