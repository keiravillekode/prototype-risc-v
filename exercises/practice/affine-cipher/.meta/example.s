.section .rodata
inverses: .byte 0, 1, 0, 9, 0, 21, 0, 15, 0, 3, 0, 19, 0, 0, 0, 7, 0, 23, 0, 11, 0, 5, 0, 17, 0, 25

.text
.globl encode
.globl decode

/* extern void encode(char *buffer, const char *phrase, unsigned a, unsigned b); */
encode:
        la      t0, inverses
        add     t0, t0, a2
        lb      t0, 0(t0)               /* inverse of a */
        li      a4, 5                   /* group length */
        bnez    t0, process

        j       end_string


/* extern void decode(char *buffer, const char *phrase, unsigned a, unsigned b); */
decode:
        la      t0, inverses
        add     t0, t0, a2
        lb      t0, 0(t0)               /* inverse of a */
        li      a4, -1                  /* no groups */
        li      t1, 26
        beqz    t0, end_string

        move    a2, t0
        sub     t1, t1, t0
        mul     a3, a3, t1              /* b * (26 - inverse of a) */


process:
        move    t1, a4                  /* remaining letters in group */
        li      t4, 10
        li      t5, 26
        li      t6, 32                  /* ' ', also 'a' - 'A' */
        li      a5, '0'
        li      a6, 'a'
        li      a7, 'z'
        j       .read

.examine:
        sub     t3, t2, a5
        bltu    t3, t4, .accept         /* digit? */

        or      t3, t2, t6              /* force lower case */
        sub     t3, t3, a6
        bgeu    t3, t5, .read           /* non-letter? */

        mul     t3, a2, t3
        add     t3, t3, a3              /* a * letter + b */
        rem     t3, t3, t5
        add     t2, a6, t3

.accept:
        bnez    t1, .write
        sb      t6, 0(a0)               /* store space */
        addi    a0, a0, 1               /* Increment output pointer */
        move    t1, a4                  /* remaining letters in group */

.write:
        sb      t2, 0(a0)               /* store letter or digit */
        addi    a0, a0, 1               /* Increment output pointer */
        addi    t1, t1, -1              /* decrement remaining letters in group */

.read:
        lb      t2, 0(a1)
        addi    a1, a1, 1               /* Increment input pointer */
        bnez    t2, .examine


end_string:
        sb      zero, 0(a0)             /* store null terminator */
        ret
