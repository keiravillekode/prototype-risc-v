.equ INVALID_NUMBER, -1

.text
.globl steps

/* extern int steps(long number); */
steps:
        move    t0, a0
        li      t1, 1
        li      t3, 3
        move    a0, zero
        bge     t0, t1, .compare_one

        li      a0, INVALID_NUMBER
        ret

.check_parity:
        and     t2, t0, t1
        beqz    t2, .even

        mul     t0, t0, t3
        add     t0, t0, t1
        add     a0, a0, t1

.even:
        srl     t0, t0, 1
        add     a0, a0, t1

.compare_one:
        bne     t0, t1, .check_parity

        ret
