.text
.globl abbreviate

/* extern void abbreviate(char *buffer, const char *phrase); */
abbreviate:
        li      t5, '\''
        li      t6, 26

.punctuation:
        lb      t0, 0(a1)
        addi    a1, a1, 1
        beqz    t0, .end

        andi    t0, t0, -33            /* force upper case */
        addi    t1, t0, -'A'
        bgeu    t1, t6, .punctuation

        sb      t0, 0(a0)
        addi    a0, a0, 1

.letter:
        lb      t0, 0(a1)
        addi    a1, a1, 1
        beqz    t0, .end

        beq     t0, t5, .letter

        andi    t0, t0, -33            /* force upper case */
        addi    t1, t0, -'A'
        bltu    t1, t6, .letter

        j       .punctuation

.end:
        sb      zero, 0(a0)
        ret
