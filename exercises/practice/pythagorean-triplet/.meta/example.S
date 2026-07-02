.globl triplets_with_sum

/*
| Register | Usage         | Type    | Description                   |
| -------- | ------------- | ------- | ----------------------------- |
| `a0`     | output        | integer | number of triplets            |
| `a0`     | input         | integer | N, sum of sides of triangle   |
| `a1`     | input/output  | address | a values                      |
| `a2`     | input/output  | address | b values                      |
| `a3`     | input/output  | address | c values                      |
| `t0`     | temporary     | address | start of a values             |
| `t1`     | temporary     | integer | a                             |
| `t2`     | temporary     | integer | b                             |
| `t3`     | temporary     | integer | c                             |
| `t4`     | temporary     | integer | a*a + b*b - c*c               |
| `t5`     | temporary     | integer |                               |
*/

/* extern size_t triplets_with_sum(uint32_t n, uint32_t *a, uint32_t *b, uint32_t *c); */
triplets_with_sum:
        move    t0, a1                  /* start of a values */
        move    t1, zero                /* Initialize a */
        srl     t2, a0, 1               /* Initialize b */

increment_a:
        addi    t1, t1, 1
        bleu    t2, t1, return          /* Stop immediately if b <= a */

assess:
        sub     t3, a0, t1
        sub     t3, t3, t2              /* c = N - a - b */
        mul     t4, t1, t1
        mul     t5, t2, t2
        add     t4, t4, t5
        mul     t5, t3, t3
        sub     t4, t4, t5
        blt     t4, zero, increment_a

        bgt     t4, zero, decrement_b

        sw      t1, 0(a1)
        sw      t2, 0(a2)
        sw      t3, 0(a3)
        addi    a1, a1, 4               /* Increment pointer for a */
        addi    a2, a2, 4               /* Increment pointer for b */
        addi    a3, a3, 4               /* Increment pointer for c */

decrement_b:
        addi    t2, t2, -1
        bgtu    t2, t1, assess          /* Stop immediately if b <= a */

return:
        sub     a0, a1, t0              /* compute number of triplets */
        srl     a0, a0, 2
        ret
