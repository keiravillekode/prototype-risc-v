.text
.globl sieve

/*
| Register | Usage        | Type    | Description                            |
| -------- | ------------ | ------- | -------------------------------------- |
| `a0`     | input        | address | destination array for prime numbers    |
| `a0`     | output       | integer | number of primes                       |
| `a1`     | input        | integer | limit                                  |
| `a2`     | temporary    | integer | size of table                          |
| `a3`     | temporary    | integer | 1                                      |
| `a4`     | temporary    | address | table last                             |
| `sp`     | stack        | address | stack pointer, table begin             |
| `t0`     | temporary    | address | output pointer                         |
| `t1`     | temporary    | address | pointer into table                     |
| `t2`     | temporary    | byte    | table entry                            |
| `t3`     | temporary    | integer | candidate prime                        |
| `t4`     | temporary    | address | pointer to multiple of candidate prime |
*/

/* extern size_t sieve(uint32_t *primes, uint32_t limit); */
sieve:
        move    t0, a0
        addi    a2, a1, 8
        andi    a2, a2, -8              /* limit, rounded up to next multiple of 8 */
        li      a3, 1
        sub     sp, sp, a2
        add     a4, sp, a1              /* pointer to sp + limit */
        addi    t1, a4, 1

fill:
        addi    t1, t1, -1
        sb      zero, 0(t1)
        bne     t1, sp, fill

        addi    t1, t1, 1
        j       advance

check_prime:
        lb      t2, 0(t1)
        bnez    t2, advance             /* composite */

        sub     t3, t1, sp
        sw      t3, 0(t0)               /* output prime */
        addi    t0, t0, 4

        mul     t4, t3, t3
        add     t4, sp, t4
        j       compare_pointers

update_table:
        sb      a3, 0(t4)               /* mark as composite */
        add     t4, t4, t3

compare_pointers:
        bleu    t4, a4, update_table    /* repeat while multiple <= limit */

advance:
        addi    t1, t1, 1               /* advance to next candidate */
        bleu    t1, a4, check_prime     /* repeat while candidate <= limit */

return:
        sub     a0, t0, a0
        srli    a0, a0, 2               /* calculate number of output values */
        add     sp, sp, a2              /* restore original stack pointer */
        ret
