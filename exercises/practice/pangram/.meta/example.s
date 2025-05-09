.text
.globl is_pangram

/* extern int is_pangram(const char *sentence); */
is_pangram:
        move    t0, zero                /* set of letters seen */
        li      t5, 1
        li      t6, 26
        j       .read

.update:
        ori     t1, t1, 32              /* force lower-case */
        addi    t1, t1, -'a'
        bgeu    t1, t6, .read           /* not alphabetic? */

        sll     t2, t5, t1
        or      t0, t0, t2

.read:
        lb      t1, 0(a0)
        addi    a0, a0, 1               /* increment input pointer */
        bnez    t1, .update

        addi    a0, t0, 1               /* 2**26 iff sentence contains all letters */
        srli    a0, a0, 26
        ret
