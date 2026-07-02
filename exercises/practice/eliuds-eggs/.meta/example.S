.text
.globl egg_count

/* extern int egg_count(size_t number); */
egg_count:
        move    t0, a0
        move    a0, zero
        j       .check

.loop:
        addi    a0, a0, 1
        sub     t1, zero, t0
        and     t1, t0, t1
        sub     t0, t0, t1

.check:
        bnez    t0, .loop

        ret
