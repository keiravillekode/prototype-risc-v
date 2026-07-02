.text
.globl factors

/* extern size_t factors(uint32_t* dest, uint32_t value); */
factors:
        move    t0, a0                  /* start of output */
        li      t1, 1
        bleu    a1, t1, .end

.increment:
        addi    t1, t1, 1

.check:
        mul     t2, t1, t1
        bltu    a1, t2, .last           /* does factor * factor exceed value? */

.mod:
        rem     t2, a1, t1
        bnez    t2, .increment          /* next candidate factor */

        div     a1, a1, t1
        sw      t1, 0(a0)               /* output factor */
        addi    a0, a0, 4
        bgeu    a1, t1, .check

.end:
        sub     a0, a0, t0
        srl     a0, a0, 2
        ret

.last:
        move    t1, a1
        j       .mod
