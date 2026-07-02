.text
.globl annotate

/*
| Register | Usage        | type    | Description                                   |
| -------- | ------------ | ------- | --------------------------------------------- |
| `a0`     | input/output | address | null-terminated output string                 |
| `a1`     | input        | address | null-terminated input string                  |
| `a1`     | temporary    | byte    | flower character '*'                          |
| `a2`     | temporary    | address | pointer into input                            |
| `a3`     | temporary    | address | location of input's null terminator           |
| `a4`     | temporary    | address | row of adjacent square                        |
| `a5`     | temporary    | address | previous row (or current for first row)       |
| `a6`     | temporary    | address | current row                                   |
| `a7`     | temporary    | address | next row (or current for last row)            |
| `t0`     | temporary    | integer | previous column (or current for first column) |
| `t1`     | temporary    | integer | current column                                |
| `t2`     | temporary    | integer | next column (or current for last column)      |
| `t3`     | temporary    | byte    | input character                               |
| `t4`     | temporary    | integer | line length (including newline character)     |
| `t5`     | temporary    | integer | column of adjacent square                     |
| `t6`     | temporary    | integer | number of adjacent flowers                    |
*/

/* extern void annotate(char *buffer, const char *garden); */
annotate:
        move    a2, a1
        lb      t3, 0(a2)               /* read first byte of garden */
        beqz    t3, return

find_newline:
        lb      t3, 0(a2)
        addi    a2, a2, 1
        li      t6, '\n'
        bne     t3, t6, find_newline
        sub     t4, a2, a1              /* line length (including newline character) */
        move    a2, a1

find_null:
        add     a2, a2, t4              /* jump ahead by line length */
        lb      t3, 0(a2)
        bnez    t3, find_null
        move    a3, a2                  /* location of input's null terminator */

        move    a6, a1
        move    a7, a1                  /* start of first row */
        li      a1, '*'                 /* flower character */

next_row:
        move    t1, zero                /* first column */
        move    t2, zero
        move    a5, a6                  /* current row becomes previous row */
        move    a6, a7                  /* next row becomes current row */

        add     a7, a6, t4              /* next row */
        bne     a7, a3, first_column
        move    a7, a6                  /* last row */

first_column:
        li      t0, 1
        beq     t4, t0, write_newline   /* jump ahead if rows contain no squares */

next_column:
        move    t0, t1                  /* current column becomes previous column */
        move    t1, t2                  /* next column becomes current column */
        addi    t2, t1, 2

        move    t3, t2
        move    t2, t1
        beq     t3, t4, check_flower    /* no more columns? */

        addi    t2, t2, 1               /* next column */

        check_flower:
        add     a2, a6, t1              /* address of garden square */
        lb      t3, 0(a2)
        beq     t3, a1, write_square    /* jump ahead if we have reached a flower */

        move    t6, zero                /* number of adjacent flowers */
        sub     a4, a5, t4

adjacent_row:
        add     a4, a4, t4              /* address of adjacent row: a5, a5+t4, a7 */
        addi    t5, t0, -1

adjacent_column:
        addi    t5, t5, 1               /* index of adjacent column: t0, t0+1, t2 */

        add     a2, a4, t5              /* address of adjacent square */
        lb      t3, 0(a2)
        bne     t3, a1, next_adjacent
        addi    t6, t6, 1               /* update flower count */

next_adjacent:
        bne     t5, t2, adjacent_column
        bne     a4, a7, adjacent_row

        li      t3, ' '
        beqz    t6, write_square
        addi    t3, t6, '0'             /* flower count, as aSCII digit */

write_square:
        sb      t3, 0(a0)
        addi    a0, a0, 1               /* increment output pointer */
        bne     t1, t2, next_column

write_newline:
        li      t6, '\n'
        sb      t6, 0(a0)               /* write '\n' */
        addi    a0, a0, 1
        bne     a6, a7, next_row

return:
        sb      zero, 0(a0)             /* null terminator */
        ret
