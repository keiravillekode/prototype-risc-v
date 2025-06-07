.globl triplets_with_sum

/*
For every Pythagorean triplet with total a + b + c = N,
    a² + b² = c²
<=> a² + b² = (N - a - b)², substituting c
<=> 0 = N² - 2*N*a - 2*N*b + 2*a*b
<=> (2*N - 2*a) b = (N² - 2*N*a)
<=> b = (N² - 2*N*a) / (2*N - 2*a)
The denominator is never 0, as N exceeds a side length.

| Register | Usage         | Type    | Description                   |
| -------- | ------------- | ------- | ----------------------------- |
| `a0`     | output        | integer | number of triplets            |
| `a0`     | input         | integer | N, sum of sides of triangle   |
| `a1`     | input/output  | address | a values                      |
| `a2`     | input/output  | address | b values                      |
| `a3`     | input/output  | address | c values                      |
| `a4`     | temporary     | address | start of a values             |
| `t0`     | temporary     | integer | remainder                     |
| `t1`     | temporary     | integer | a                             |
| `t2`     | temporary     | integer | b                             |
| `t3`     | temporary     | integer | c                             |
| `t4`     | temporary     | integer | numerator                     |
| `t5`     | temporary     | integer | denominator                   |
*/

/* extern size_t triplets_with_sum(uint32_t n, uint32_t *a, uint32_t *b, uint32_t *c); */
triplets_with_sum:
        move    a4, a1                  /* start of a values */
        li      t3, 2
        blt     a0, t3, return          /* Stop immediately if N < 2 */
        move    t1, zero                /* Initialize a */
        j       increment_a

check_remainder:
        bnez    t0, increment_a
        sub     t3, a0, t1
        sub     t3, t3, t2              /* c = N - a - b */

        sw      t1, 0(a1)
        sw      t2, 0(a2)
        sw      t3, 0(a3)
        addi    a1, a1, 4               /* Increment pointer for a */
        addi    a2, a2, 4               /* Increment pointer for b */
        addi    a3, a3, 4               /* Increment pointer for c */

increment_a:
        addi    t1, t1, 1
        sub     t5, a0, t1              /* N - a */
        sub     t4, t5, t1              /* N - 2*a */
        sll     t5, t5, 1               /* denominator = 2*N - 2*a */
        mul    t4, a0, t4               /* numerator = N² - 2*N*a */
        div     t2, t4, t5              /* b */
        rem     t0, t4, t5              /* remainder */

        bgt     t2, t1, check_remainder /* loop while b > a */

return:
        sub     a0, a1, a4              /* compute number of triplets */
        srl     a0, a0, 2
        ret
