.text
.globl sum

/* extern uint32_t sum(uint32_t limit, const uint32_t *factors, size_t factor_count); */
sum:
        move    t0, a0
        move    a0, zero
        beqz    a2, .return

        slli    a2, a2, 2
        add     a2, a1, a2              /* end of factors */
        bnez    t0, .decrement

.return:
        ret

.accept:
        add     a0, a0, t0

.decrement:
        addi    t0, t0, -1
        beqz    t0, .return

        move    t1, a1

.test_factor:
        lw      t2, 0(t1)
        rem     t2, t0, t2
        beqz    t2, .accept

        addi    t1, t1, 4
        bne     t1, a2, .test_factor

        j       .decrement
