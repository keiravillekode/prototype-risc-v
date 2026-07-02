.text
.globl encode
.globl decode

/* extern void encode(char *buffer, const char *phrase); */
encode:
        li      a2, 5                   /* group length */
        j       process

/* extern void decode(char *buffer, const char *phrase); */
decode:
        li      a2, -1                  /* no groups */
        j       process

process:
        move    t1, a2                  /* remaining letters in group */
        li      t4, 10
        li      t5, 26
        li      t6, 32                  /* ' ', also 'a' - 'A' */
        li      a5, '0'
        li      a6, 'a'
        li      a7, 'z'
        j       .read

.examine:
        sub     t3, t2, a5
        bltu    t3, t4, .accept         /* unsigned < */

        or      t3, t2, t6              /* force lower case */
        sub     t3, t3, a6
        bgeu    t3, t5, .read           /* unsigned >= */

        sub     t3, a7, t3              /* 'z' - letter index */
        and     t2, t2, t6
        or      t2, t2, t3              /* rotated letter, with original case */

.accept:
        bnez    t1, .write
        sb      t6, 0(a0)               /* store space */
        addi    a0, a0, 1               /* Increment output pointer */
        move    t1, a2                  /* remaining letters in group */

.write:
        sb      t2, 0(a0)               /* store letter or digit */
        addi    a0, a0, 1               /* Increment output pointer */
        addi    t1, t1, -1              /* decrement remaining letters in group */

.read:
        lb      t2, 0(a1)
        addi    a1, a1, 1               /* Increment input pointer */
        bnez    t2, .examine

        sb      zero, 0(a0)             /* store null terminator */
        ret
