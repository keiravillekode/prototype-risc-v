.text
.globl reverse

/* extern void reverse(char *str); */
reverse:
        move    t0, a0                  /* copy address */

.scan:
        lb      t1, 0(t0)
        addi    t0, t0, 1               /* increment address */
        bnez    t1, .scan

        addi    t0, t0, -1
        beq     t0, a0, .return         /* empty string? */

.swap:
        addi    t0, t0, -1
        beq     t0, a0, .return

        lb      t1, 0(t0)
        lb      t2, 0(a0)
        sb      t2, 0(t0)
        sb      t1, 0(a0)

        addi    a0, a0, 1
        bne     t0, a0, .swap

.return:
        ret
