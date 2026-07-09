.text
.globl saddle_points

/*
| Register | Type    | Description                                                |
| -------- | ------- | ---------------------------------------------------------- |
| `a0`     | address | output iterator                                            |
| `a1`     | address | matrix input iterator                                      |
| `a2`     | integer | row_count*4                                                |
| `a3`     | integer | column_count*4                                             |
| `a4`     | integer | matrix bytes: row_count*column_count*4                     |
| `a5`     | address | start of output                                            |
| `a6`     | address | original stack pointer, end of largest-in-rows array       |
| `a7`     | address | largest-in-rows array                                      |
| `sp`     | address | stack pointer,  smallest-in-columns array                  |
| `t0`     | integer | current matrix entry                                       |
| `t1`     | address | end of current matrix row                                  |
| `t2`     | address | largest-in-rows array                                      |
| `t3`     | integer | largest in current row                                     |
| `t4`     | address | smallest-in-columns array                                  |
| `t5`     | integer | smallest in current column                                 |
*/

/* extern size_t saddle_points(point_t *output, const int32_t *matrix, size_t row_count, size_t column_count); */
saddle_points:
        slli    a2, a2, 2               /* row_count*4 = bytes for largest-in-rows array */
        mul     a4, a2, a3              /* matrix bytes */
        slli    a3, a3, 2               /* col_count*4 = bytes for smallest-in-columns array */
        move    a6, sp
        sub     sp, sp, a2
        move    a7, sp                  /* address for largest-in-rows array */
        move    t2, sp                  /* address for largest-in-rows array */
        sub     sp, sp, a3              /* address for smallest-in-columns array */

.largest_next_row:
        add     t1, a1, a3              /* address in matrix for end of current row */
        lw      t3, 0(a1)               /* largest in current row */

.largest_within_row:
        lw      t0, 0(a1)
        addi    a1, a1, 4
        ble     t0, t3, .not_larger

        move    t3, t0

.not_larger:
        bne     a1, t1, .largest_within_row

        sw      t3, 0(t2)
        addi    t2, t2, 4
        bne     t2, a6, .largest_next_row

        sub     t2, a6, a2              /* largest-in-rows array */
        move    t4, sp                  /* smallest-in-columns array */
        sub     a1, a1, a4              /* reset matrix input iterator */

.smallest_next_column:
        add     t1, a1, a4
        lw      t5, 0(a1)               /* smallest in current column */

.smallest_within_column:
        lw      t0, 0(a1)
        add     a1, a1, a3
        bge     t0, t5, .not_smaller

        move    t5, t0

.not_smaller:
        bne     a1, t1, .smallest_within_column

        sw      t5, 0(t4)
        addi    t4, t4, 4
        sub     a1, a1, a4
        addi    a1, a1, 4
        bne     t4, t2, .smallest_next_column

        move    a5, a0
        sub     a1, a1, a3              /* reset cursor to base (was at base + one row) */

.scan_next_row:
        add     t1, a1, a3              /* address in matrix for end of current row */
        lw      t3, 0(t2)               /* largest in current row */
        addi    t2, t2, 4
        move    t4, sp                  /* pointer into smallest-in-columns array */

.scan_within_row:
        lw      t0, 0(a1)
        addi    a1, a1, 4
        lw      t5, 0(t4)               /* smallest in current column */
        addi    t4, t4, 4
        blt     t0, t3, .not_saddle

        bgt     t0, t5, .not_saddle

        sub     t0, t2, a7
        srli    t0, t0, 2               /* 1-based row index */
        sw      t0, 0(a0)
        sub     t0, t4, sp
        srli    t0, t0, 2               /* 1-based column index */
        sw      t0, 4(a0)
        addi    a0, a0, 8

.not_saddle:
        bne     a1, t1, .scan_within_row

        bne     t2, a6, .scan_next_row

        sub     a0, a0, a5
        srli    a0, a0, 3               /* number of points returned */
        move    sp, a6
        ret
