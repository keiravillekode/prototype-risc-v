.text
.globl leap_year

/* extern int leap_year(long year); */
leap_year:
        li      t0, 100
        rem     t1, a0, t0
        bnez    t1, .test

        div     a0, a0, t0

.test:
        andi    a0, a0, 3
        slti    a0, a0, 1
        ret
