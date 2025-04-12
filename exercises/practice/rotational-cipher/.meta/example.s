.text
.globl rotate

/* extern void rotate(char *buffer, const char *text, long shift_key); */
rotate:
        li      t6, 26
        j       .read

.loop:
        ori     t1, t0, 32              /* force lower case */
        addi    t1, t1, -'a'
        bgeu    t1, t6, .write

        andi    t0, t0, 32              /* 32 if lower case, otherwise 0 */
        add     t1, t1, a2              /* shift */
        blt     t1, t6, .encode

        sub     t1, t1, t6

.encode:
        add     t1, t1, 'A'
        or      t0, t1, t0              /* restore original case */

.write:
        sb      t0, 0(a0)
        addi    a0, a0, 1               /* increment output pointer */

.read:
        lb      t0, 0(a1)
        addi    a1, a1, 1               /* increment input pointer */
        bnez    t0, .loop

        sb      zero, 0(a0)
        ret
