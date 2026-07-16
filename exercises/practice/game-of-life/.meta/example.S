.text
.globl tick

/*
| Register | Usage        | Type    | Description                     |
| -------- | ------------ | ------- | ------------------------------- |
| `a0`     | input/output | address | grid for next generation        |
| `a1`     | input        | address | grid for current generation     |
| `a2`     | input        | integer | number of rows                  |
| `a3`     | input        | integer | number of columns               |
| `a5`     | temporary    | integer | number of alive neighbours      |
| `a6`     | temporary    | integer | 3-row total for current column  |
| `a7`     | temporary    | integer | 3-row total for next column     |
| `t0`     | temporary    | integer | previous row, shifted           |
| `t1`     | temporary    | integer | current row, shifted            |
| `t2`     | temporary    | integer | next row, shifted               |
| `t3`     | temporary    | bit     | curent cell                     |
| `t4`     | temporary    | bit     | next cell                       |
| `t5`     | temporary    | integer | row for output                  |
| `t6`     | temporary    | integer | current column                  |
| `s0`     | temporary    | integer | previous row                    |
| `s1`     | temporary    | integer | current row                     |
| `s2`     | temporary    | integer | next row                        |
*/

/* extern void tick(uint32_t *buffer, const uint32_t *matrix, size_t row_count, size_t column_count); */
tick:
        addi    sp, sp, -16             /* preserve original register values on stack */
        sw      s0, 0(sp)
        sw      s1, 4(sp)
        sw      s2, 8(sp)
        beqz    a2, return              /* 0 rows? */

        move    s1, zero
        lw      s2, 0(a1)               /* read first row */
        addi    a1, a1, 4

outer:
        addi    a2, a2, -1
        move    s0, s1                  /* previous row */
        move    s1, s2                  /* current row */
        move    s2, zero
        beqz    a2, process_row

        lw      s2, 0(a1)               /* read next row */
        addi    a1, a1, 4

process_row:
        move    t5, zero
        move    t6, zero
        move    t0, s0
        move    t1, s1
        move    t2, s2
        move    a6, zero

        andi    a7, t0, 1
        andi    t4, t2, 1
        add     a7, a7, t4
        andi    t4, t1, 1               /* first cell */
        add     a7, a7, t4

        beqz    a3, write               /* zero columns? */

inner:
        srli    t0, t0, 1               /* previous row, shifted */
        srli    t1, t1, 1               /* current row, shifted */
        srli    t2, t2, 1               /* next row, shifted */
        move    t3, t4                  /* current cell */
        add     a5, a6, a7
        move    a6, a7                  /* total for current column across 3 rows */

        andi    a7, t0, 1
        andi    t4, t2, 1
        add     a7, a7, t4
        andi    t4, t1, 1               /* next cell */
        add     a7, a7, t4

        add     a5, a5, a7
        sub     a5, a5, t3              /* total of 8 neighbours */
        or      a5, a5, t3              /* if current cell is alive, treat 2 alive neighbours as 3 */
        addi    a5, a5, -3
        seqz    a5, a5                  /* 1 if 3 neighbours, otherwise 0 */

        sll     a5, a5, t6
        or      t5, t5, a5
        addi    t6, t6, 1
        bne     t6, a3, inner           /* remaining columns? */

write:
        sw      t5, 0(a0)               /* write row */
        addi    a0, a0, 4
        bnez    a2, outer               /* remaining rows? */

return:
        lw      s2, 8(sp)               /* restore original register values */
        lw      s1, 4(sp)
        lw      s0, 0(sp)
        addi    sp, sp, 16
        ret
