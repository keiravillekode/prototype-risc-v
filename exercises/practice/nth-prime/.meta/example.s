.text
.globl prime

/*
| Register | Usage      | Type    | Description             |
| -------- | ---------- | ------- | ----------------------- |
| `a0`     | output     | integer | prime                   |
| `a0`     | input      | integer | remaining primes        |
| `a1`     | temporary  | integer | 6                       |
| `t0`     | temporary  | integer | prime candidate         |
| `t1`     | temporary  | integer | prime step              |
| `t2`     | temporary  | integer | factor candidate        |
| `t3`     | temporary  | integer | factor step             |
*/

/* extern unsigned prime(unsigned number); */
prime:
        li      a1, 6
        li      t1, 4                   /* prime step */
        li      t0, 1                   /* prime candidate will be 5 */
        addi    a0, a0, -2
        bgtz    a0, outer

        addi    a0, a0, 3               /* Prime 1 is 2, Prime 2 is 3 */
        ret

found_prime:
        addi    a0, a0, -1
        bnez    a0, outer
        move    a0, t0
        ret

outer:
        add     t0, t0, t1              /* prime candidate */
        sub     t1, a1, t1              /* prime step */
        li      t3, 4                   /* factor step */
        li      t2, 1                   /* factor candidate will be 5 */

inner:
        add     t2, t2, t3              /* factor candidate */
        sub     t3, a1, t3              /* factor step */
        mul     t4, t2, t2
        bgt     t4, t0, found_prime
        rem     t5, t0, t2
        bnez    t5, inner
        j       outer
