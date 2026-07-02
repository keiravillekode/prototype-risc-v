.text
.globl truncate

/* extern void truncate(char *buffer, const char *phrase); */
truncate:
        li      t0, 6
        li      t6, 0x80

.read:
        lb      t1, 0(a1)
        addi    a1, a1, 1
        sb      t1, 0(a0)
        addi    a0, a0, 1
        beqz    t1, .return             /* null terminator */

        andi    t2, t1, 0xC0
        beq     t2, t6, .read           /* non-initial byte of code point */

        addi    t0, t0, -1
        bnez    t0, .read

.return:
        sb      zero, -1(a0)
        ret
