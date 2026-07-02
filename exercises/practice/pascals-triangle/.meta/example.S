.text
.globl rows

/*
| Register | Usage        | Type    | Description                      |
| -------- | ------------ | ------- | -------------------------------- |
| `a0`     | input/output | address | start of array of words          |
| `a1`     | input        | integer | number of triangle rows          |
| `a2`     | temporary    | integer | left value from previous row     |
| `a3`     | temporary    | integer | right value from previous row    |
| `a4`     | temporary    | integer | sum two values from previous row |
| `t0`     | temporary    | address | output pointer                   |
| `t1`     | temporary    | integer | number of bytes in a1 words      |
| `t2`     | temporary    | integer | row length, in bytes             |
| `t3`     | temporary    | address | pointer into previous row        |
| `t4`     | temporary    | address | initial 1 of current row         |
| `t5`     | temporary    | address | final 1 of current row           |
*/

/* extern size_t rows(uint32_t *dest, size_t count); */
rows:
        move    t0, a0                  /* output pointer */
        beqz    a1, done                /* stop immediately if 0 rows */

        sll     t1, a1, 2               /* number of bytes in a1 words */
        move    t2, zero                /* row length, in bytes */
        li      a3, 1                   /* value for first row */

next_row:
        move   t4, t0                   /* address of initial 1 of current row */
        add    t5, t0, t2               /* address of final 1 of current row */
        addi   t2, t2, 4                /* row length, in bytes */
        move   a2, zero                 /* left value from previous row */
        beq    t0, t5, last_column

next_column:
        lw     a3, 0(t3)                /* read from previous row */
        addi   t3, t3, 4
        add    a4, a2, a3               /* sum two values from previous row */
        move   a2, a3
        sw     a4, 0(t0)                /* write output */
        addi   t0, t0, 4
        bne    t0, t5, next_column

last_column:
        sw     a3, 0(t0)                /* write output */
        addi   t0, t0, 4
        move   t3, t4                   /* start of most recent row */
        bne    t2, t1, next_row         /* repeat until we have final row length */

done:
        sub    a0, t0, a0               /* subtract start of output */
        srl    a0, a0, 2                /* convert to number of words */
        ret
